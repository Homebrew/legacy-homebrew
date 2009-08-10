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
#
require 'pathname'

# we enhance pathname to make our code more readable
class Pathname
  def mv dst    
    FileUtils.mv to_s, dst
  end
  
  def rename newname
    raise unless file?
    dst=dirname+newname
    dst.unlink rescue nil
    mv dst
  end

  def install src
    if src.is_a? Array
      src.collect {|src| install src }
    elsif File.exist? src
      mkpath
      if File.symlink? src
        # we use the BSD mv command because FileUtils copies the target and
        # not the link! I'm beginning to wish I'd used Python quite honestly!
        raise unless Kernel.system 'mv', src, to_s and $? == 0
      else
        # we mv when possible as it is faster and you should only be using
        # this function when installing from the temporary build directory
        FileUtils.mv src, to_s
      end
      return self+src
    end
  end

  def cp dst
    if file?
      FileUtils.cp to_s, dst
    else
      FileUtils.cp_r to_s, dst
    end
  end

  # extended to support the double extensions .tar.gz and .tar.bz2
  def extname
    /(\.tar\.(gz|bz2))$/.match to_s
    return $1 if $1
    return File.extname(to_s)
  end

  # for filetypes we support, basename without extension
  def stem
    return File.basename(to_s, extname)
  end

  def version
    # eg. boost_1_39_0
    /((\d+_)+\d+)$/.match stem
    return $1.gsub('_', '.') if $1

    # eg. foobar-4.5.1-1
    /-((\d+\.)*\d+-\d+)$/.match stem
    return $1 if $1

    # eg. foobar-4.5.1
    /-((\d+\.)*\d+)$/.match stem
    return $1 if $1

    # eg. foobar-4.5.1b
    /-((\d+\.)*\d+([abc]|rc\d))$/.match stem
    return $1 if $1

    # eg foobar-4.5.0-beta1
    /-((\d+\.)*\d+-beta\d+)$/.match stem
    return $1 if $1

    # eg. foobar4.5.1
    /((\d+\.)*\d+)$/.match stem
    return $1 if $1

    # eg. otp_src_R13B (this is erlang's style)
    # eg. astyle_1.23_macosx.tar.gz
    stem.scan /_([^_]+)/ do |match|
      return match.first if /\d/.match $1
    end
  end
end
