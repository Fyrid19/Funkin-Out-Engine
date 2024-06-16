package backend;

import flixel.util.FlxSave;

class FunkinData {
    public static var initialized:Bool = false;

    public static var save:FlxSave; // probably not the best way of going about this but eh
    public static var data:Map<String, Dynamic> = null;
    public static var dataDefault:Map<String, Dynamic> = [
        'downScroll' => false,
        'ghostTapping' => false,
        'flashingLights' => true,
        'cameraZoom' => true,
        'unfocusPause' => true,
        'globalAntialiasing' => true,
        'maxFramerate' => 60
    ];

    public static function initialize() {
        save = new FlxSave();
        save.bind('prototype', 'fyridev');
        data = dataDefault;
        loadData();

        if (data != null)
            initialized = true;
    }

    public static function loadData() {
        var newData:Bool = false;
        for (key => value in data) {
            if (Reflect.getProperty(save.data, key) == null) {
                Reflect.setProperty(save.data, key, value);
                newData = true;
            } else {
                data[key] = Reflect.getProperty(save.data, key);
            }
        }
        if (!newData)
            trace('Loaded data successfully!');
        else
            trace('No data was found, your data has been reset');
    }

    public static function saveData() {
        for (key => value in data) {
            Reflect.setProperty(save.data, key, value);
        }
        trace('Data saved!');
    }

    public static function setToDefault() {
        for (key => value in dataDefault) {
            Reflect.setProperty(save.data, key, value);
        }
        data = dataDefault;
        trace('Data reset');
    }
}