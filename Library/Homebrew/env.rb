#  Copyright 2009 Max Howell <max@methylblue.com>
#
#  This file is part of Homebrew.
#
#  Homebrew is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Homebrew is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Homebrew.  If not, see <http://www.gnu.org/licenses/>.

require 'pathname+yeast'
require 'utils'

# TODO if whoami == root then use /Library/Caches/Homebrew instead
HOMEBREW_VERSION='0.3'
HOMEBREW_CACHE=Pathname.new("~/Library/Caches/Homebrew").expand_path
HOMEBREW_PREFIX=Pathname.new(__FILE__).dirname.parent.parent.cleanpath
HOMEBREW_CELLAR=HOMEBREW_PREFIX+'Cellar'
