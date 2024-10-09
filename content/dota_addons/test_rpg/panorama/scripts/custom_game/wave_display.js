(function () {
    var waveLabel = $("#WaveLabel");

    GameEvents.Subscribe("wave_update", function (eventData) {
        var waveNumber = eventData.wave;
        waveLabel.text = "Wave: " + waveNumber;
    });
})();
