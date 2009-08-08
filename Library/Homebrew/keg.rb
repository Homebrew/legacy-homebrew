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
class Keg <Pathname
  def initialize path
    super path
    raise "#{to_s} is not a valid keg" unless parent.parent == HOMEBREW_CELLAR
    raise "#{to_s} is not a directory" unless directory?
  end

  def uninstall
    chmod_R 0777 # ensure we have permission to delete
    rmtree
    parent.rmdir_if_possible
  end

  def link
    $n=0
    $d=0

    mkpaths=(1..9).collect {|x| "man/man#{x}"} <<'man'<<'doc'<<'locale'<<'info'<<'aclocal'

    # yeah indeed, you have to force anything you need in the main tree into
    # these dirs REMEMBER that *NOT* everything needs to be in the main tree
    link_dir('etc') {:mkpath}
    link_dir('bin') {:link}
    link_dir('lib') {|path| :mkpath if %w[pkgconfig php perl5].include? path.to_s}
    link_dir('include') {:link}
    link_dir('share') {|path| :mkpath if mkpaths.include? path.to_s}

    return $n+$d
  end

private
  # symlinks the contents of self+foo recursively into /usr/local/foo
  def link_dir foo
    root=self+foo

    root.find do |src|
      next if src == root

      dst=HOMEBREW_PREFIX+src.relative_path_from(self)
      dst.extend ObserverPathnameExtension

      if src.file?
        dst.make_relative_symlink src
      elsif src.directory?
        # no need to put .app bundles in the path, the user can just use
        # spotlight, or the open command and actual mac apps use an equivalent
        Find.prune if src.extname.to_s == '.app'

        case yield src.relative_path_from(root)
          when :skip then Find.prune
          when :mkpath then dst.mkpath
          else dst.make_relative_symlink src; Find.prune
        end
      end
    end
  end
end
