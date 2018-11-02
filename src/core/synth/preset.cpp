/* miniSynth - A Simple Software Synthesizer
   Copyright (C) 2015 Ville Räisänen <vsr at vsr.name>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "preset.h"

Preset::Preset() : timbreAmplitudes(8, 0), timbrePhases(8, 0) {
//hardcode custom church pad preset
    waveformMode = Waveform::MODE_SIN;
    env.attackTime = 50;
    env.decayTime = 400;
    env.releaseTime = 100;

    env.initialAmpl = 0;
    env.peakAmpl = 1;
    env.sustainAmpl = 0.8;

    filt.freq1 = filt.freq2 = 4000;
    filt.samplingRate = 44100;
    filt.size         = 100;
    filt.type         = Filter::FILTER_OFF;
    filt.window_type  = Filter::WINDOW_RECT;
    filt.fftTimer     = 100;

    rev.active = 1;
    rev.attenuation = 3;
    rev.delay = 8000;
    rev.samplingRate = 44100;

    timbreAmplitudes[0] = 50;
    timbreAmplitudes[1] = 15;
    timbreAmplitudes[3] = 15;
    timbreAmplitudes[7] = 50;
    timbrePhases[0] = 0;
}

Preset::~Preset() {
}
