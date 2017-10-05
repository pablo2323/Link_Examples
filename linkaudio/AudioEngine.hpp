/* Copyright 2016, Ableton AG, Berlin. All rights reserved.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  If you would like to incorporate Link into a proprietary software application,
 *  please contact <link-devs@ableton.com>.
 */

#pragma once

#define LINKHUT_AUDIO_PLATFORM_ASIO = 1
#define LINK_PLATFORM_WINDOWS = 1

// Make sure to define this before <cmath> is included for Windows
#define _USE_MATH_DEFINES
#include <ableton/Link.hpp>
#include <mutex>

namespace ableton
{
namespace linkaudio
{

class AudioEngine
{
public:
  AudioEngine(Link& link);
  void startPlaying();
  void stopPlaying();
  bool isPlaying() const;
  double beatTime() const;
  void setTempo(double tempo);
  double quantum() const;
  void setQuantum(double quantum);

private:
  struct EngineData
  {
    double requestedTempo;
    bool resetBeatTime;
    bool isPlaying;
    double quantum;
  };

  void setBufferSize(std::size_t size);
  void setSampleRate(double sampleRate);
  EngineData pullEngineData();
  void renderMetronomeIntoBuffer(Link::Timeline timeline,
    double quantum,
    std::chrono::microseconds beginHostTime,
    std::size_t numSamples);
  void audioCallback(const std::chrono::microseconds hostTime, std::size_t numSamples);

  Link& mLink;
  double mSampleRate;
  std::chrono::microseconds mOutputLatency;
  std::vector<double> mBuffer;
  EngineData mSharedEngineData;
  EngineData mLockfreeEngineData;
  std::chrono::microseconds mTimeAtLastClick;
  std::mutex mEngineDataGuard;

  friend class AudioPlatform;
};


} // namespace linkaudio
} // namespace ableton
