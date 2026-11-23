"""Interface guard for cmeresearch_msgs.

* every .msg file is registered with rosidl_generate_interfaces
* generated Python types import and round-trip through serialization
* the wire format (RIHS01 type hash) matches test/interface_hashes.yaml
* fields other packages rely on keep their type
"""

import importlib
import json
import pathlib
import re

import pytest
import yaml
from ament_index_python.packages import get_package_share_directory
from rclpy.serialization import deserialize_message, serialize_message

PKG = 'cmeresearch_msgs'
ROOT = pathlib.Path(__file__).resolve().parent.parent
SHARE = pathlib.Path(get_package_share_directory(PKG))
MSG_FILES = sorted((ROOT / 'msg').glob('*.msg'))
ACTION_FILES = sorted((ROOT / 'action').glob('*.action'))
# Every generated interface as 'msg/Name' / 'action/Name'.
INTERFACES = [f'msg/{p.stem}' for p in MSG_FILES] + [f'action/{p.stem}' for p in ACTION_FILES]
GOLDEN = yaml.safe_load((ROOT / 'test' / 'interface_hashes.yaml').read_text())

# Fields consumed by other repos (stepper driver, cmexa_base, webapp bridge).
CONTRACT = {
    'TinkerStepperCommand': {'header': 'std_msgs/Header', 'velocity': 'float', 'position': 'int32'},
    'TinkerStepperFeedback': {
        'header': 'std_msgs/Header', 'current_velocity': 'float', 'current_position': 'int32',
        'remaining_steps': 'int32', 'input_voltage': 'int32', 'current_consumption': 'int32'},
}


def msg_class(name):
    return getattr(importlib.import_module(f'{PKG}.msg'), name)


def test_every_msg_file_is_generated():
    cmake = (ROOT / 'CMakeLists.txt').read_text()
    block = re.search(r'rosidl_generate_interfaces\((.*?)\)', cmake, re.S).group(1)
    registered = set(re.findall(r'"((?:msg|action)/[^"]+\.(?:msg|action))"', block))
    on_disk = {f'msg/{p.name}' for p in MSG_FILES} | {f'action/{p.name}' for p in ACTION_FILES}
    assert on_disk == registered, (
        f'not generated: {sorted(on_disk - registered)}, '
        f'missing files: {sorted(registered - on_disk)}')


def test_golden_file_covers_every_message():
    assert set(GOLDEN) == set(INTERFACES)


@pytest.mark.parametrize('iface', INTERFACES)
def test_type_hash_is_unchanged(iface):
    data = json.loads((SHARE / f'{iface}.json').read_text())
    entry = next(t for t in data['type_hashes'] if t['type_name'] == f'{PKG}/{iface}')
    assert entry['hash_string'] == GOLDEN[iface], (
        f'{iface} wire format changed - see test/interface_hashes.yaml')


@pytest.mark.parametrize('name', [p.stem for p in MSG_FILES])
def test_serialization_round_trip(name):
    cls = msg_class(name)
    msg = cls()
    assert deserialize_message(serialize_message(msg), cls) == msg


@pytest.mark.parametrize('name', sorted(CONTRACT))
def test_consumer_contract(name):
    fields = msg_class(name).get_fields_and_field_types()
    for field, typ in CONTRACT[name].items():
        assert fields.get(field) == typ, f'{name}.{field}: {fields.get(field)} != {typ}'


def test_stepper_feedback_values_round_trip():
    cls = msg_class('TinkerStepperFeedback')
    msg = cls(current_velocity=-509.0, current_position=-12345, input_voltage=24000,
              current_consumption=800)
    out = deserialize_message(serialize_message(msg), cls)
    assert out.current_velocity == -509.0  # signed microsteps/s must survive
    assert out.current_position == -12345
    assert out.input_voltage == 24000


def test_move_steps_action_contract():
    """Goal/result/feedback fields used by cmeresearch_stepper_driver."""
    action = getattr(importlib.import_module(f'{PKG}.action'), 'MoveSteps')
    goal = action.Goal.get_fields_and_field_types()
    assert goal == {'mode': 'uint8', 'steps': 'int32', 'max_velocity': 'uint16'}
    assert action.Goal.RELATIVE == 0 and action.Goal.ABSOLUTE == 1
    assert action.Result.get_fields_and_field_types() == {
        'success': 'boolean', 'final_position': 'int32', 'message': 'string'}
    assert action.Feedback.get_fields_and_field_types() == {
        'current_position': 'int32', 'remaining_steps': 'int32', 'current_velocity': 'float'}
