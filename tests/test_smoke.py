import importlib


def test_project_packages_import():
    for name in ("assistant", "data_engineering", "engine"):
        assert importlib.import_module(name)
