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
class AbstractDownloadStrategy
  def initialize url, name, version
    @url=url
    @unique_token="#{name}-#{version}" unless name.to_s.empty? or name == '__UNKNOWN__'
  end
end

class HttpDownloadStrategy <AbstractDownloadStrategy
  def fetch
    ohai "Downloading #{@url}"
    if @unique_token
      @dl=HOMEBREW_CACHE+(@unique_token+ext)
    else
      @dl=HOMEBREW_CACHE+File.basename(@url)
    end
    unless @dl.exist?
      curl @url, '-o', @dl
    else
      puts "File already downloaded and cached"
    end
    return @dl # thus performs checksum verification
  end
  def stage
    case `file -b #{@dl}`
      when /^Zip archive data/
        safe_system 'unzip', '-qq', @dl
        chdir
      when /^(gzip|bzip2) compressed data/
        # TODO do file -z now to see if it is in fact a tar
        safe_system 'tar', 'xf', @dl
        chdir
      else
        # we are assuming it is not an archive, use original filename
        # this behaviour is due to ScriptFileFormula expectations
        @dl.mv File.basename(@url)
    end
  end
private
  def chdir
    entries=Dir['*']
    case entries.length
      when 0 then raise "Empty archive"
      when 1 then Dir.chdir entries.first rescue nil
    end
  end
  def ext
    # GitHub uses odd URLs for zip files, so check for those
    rx=%r[http://(www\.)?github\.com/.*/(zip|tar)ball/]
    if rx.match @url
      if $2 == 'zip'
        '.zip'
      else
        '.tgz'
      end
    else
      Pathname.new(@url).extname
    end
  end
end

class SubversionDownloadStrategy <AbstractDownloadStrategy
  def fetch
    ohai "Checking out #{@url}"
    @co=HOMEBREW_CACHE+@unique_token
    unless @co.exist?
      safe_system 'svn', 'checkout', @url, @co
    else
      # TODO svn up?
      puts "Repository already checked out"
    end
  end
  def stage
    # Force the export, since the target directory will already exist
    safe_system 'svn', 'export', '--force', @co, Dir.pwd
  end
end

class GitDownloadStrategy <AbstractDownloadStrategy
  def fetch
    ohai "Cloning #{@url}"
    @clone=HOMEBREW_CACHE+@unique_token
    unless @clone.exist?
      safe_system 'git', 'clone', @url, @clone
    else
      # TODO git pull?
      puts "Repository already cloned"
    end
  end
  def stage
    dst=Dir.getwd
    Dir.chdir @clone do
      # http://stackoverflow.com/questions/160608/how-to-do-a-git-export-like-svn-export
      safe_system 'git', 'checkout-index', '-af', "--prefix=#{dst}/"
    end
  end
end
