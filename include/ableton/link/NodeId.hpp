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

#include <ableton/discovery/NetworkByteStreamSerializable.hpp>
#include <algorithm>
#include <array>
#include <cstdint>
#include <string>
#include <iostream>

#ifdef __MINGW32__
# include <stdlib.h>
# include <time.h>
# define RANDOM
#else
# include <random>
# define RANDOM_DEVICE
#endif

namespace ableton
{
namespace link
{

using NodeIdArray = std::array<std::uint8_t, 8>;

struct NodeId : NodeIdArray
{
  NodeId() = default;

  NodeId(NodeIdArray rhs)
    : NodeIdArray(std::move(rhs))
  {
  }

  static NodeId random()
  {
    using namespace std;

#ifdef RANDOM_DEVICE
      random_device rd;
    mt19937 gen(rd());
#endif
#ifdef RANDOM
    srand(time(NULL));
    mt19937 gen(rand() % 100000000 + 1);
#endif
    // uint8_t not standardized for this type - use unsigned
    uniform_int_distribution<unsigned> dist(33, 126); // printable ascii chars

    NodeId nodeId;
    generate(
      nodeId.begin(), nodeId.end(), [&] { return static_cast<uint8_t>(dist(gen)); });
    std::cout << "THE GENERATED CODE IS : " << nodeId << std::endl;
    return nodeId;
  }

  friend std::ostream& operator<<(std::ostream& stream, const NodeId& id)
  {
    return stream << std::string{id.cbegin(), id.cend()};
  }

  template <typename It>
  friend It toNetworkByteStream(const NodeId& nodeId, It out)
  {
    return discovery::toNetworkByteStream(nodeId, std::move(out));
  }

  template <typename It>
  static std::pair<NodeId, It> fromNetworkByteStream(It begin, It end)
  {
    using namespace std;
    auto result =
      discovery::Deserialize<NodeIdArray>::fromNetworkByteStream(move(begin), move(end));
    return make_pair(NodeId(move(result.first)), move(result.second));
  }
};

} // namespace link
} // namespace ableton
