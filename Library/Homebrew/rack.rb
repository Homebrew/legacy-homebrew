## This file defines the `Rack` - A directory to contain `Keg`s.
##
## A rack has a @path (a `Pathname`) to it's directory.
## The HOMEBREW_CELLAR is where all racks are located.
##
## tl:dr API:
## - all = Rack.all  # list all existing, valid software installed.
## - rack = Rack.factory('wget')  # get the validated but possibly not
##                                # yet existing 'wget' rack.
## - rack.real?  # `true` if this is actually valid and existing.
## - rack.fname  # the name of this rack

require 'keg'

# TODO: Can you make Rack#formula work with formulae from taps?

# A Rack full of kegs - Make accessing racks and kegs a breeze.
class Rack
  attr :path

  def initialize(path)
    @path = Pathname.new(path)
    valid?
  end

  # Check what *would be* a valid Rack
  def valid?
    n = fname
    raise "No spaces allowed in rack: '#{n}'" unless (n =~ /\s/).nil?
    # No upper case allowed, except for __UNKNOWN__
    raise "No upper case letters allowed in rack: '#{n}'" if !(n =~ /[A-Z]/).nil? && n != '__UNKNOWN__'
    begin
      right_location = (@path.parent.realpath == HOMEBREW_CELLAR.realpath)
    rescue Exception => e
      raise e.message
    end
    raise "#{@path.parent.realpath} is not #{HOMEBREW_CELLAR.realpath} for rack '#{n}'" unless right_location
    true
  end

  # Must be `valid?` and an existing directory (or symlink to one).
  # Further, a rack is only real, if it has at least one subdir (but
  # for performance reasons, we don't check if that subdir is actually
  # a real keg.)
  def real?
    valid?
    n = fname
    raise "#{n} does not exist" unless @path.exist?
    raise "#{to_s} is not a directory" unless @path.realpath.directory?
    raise "#{n} has no subdirs" unless !@path.subdirs.empty?
    true
  end

  # Return a new, `valid?` rack or raise an exception if not.
  def self.factory name
    # Only validate but no check for `real?`, to be able to Rack.factory('foo').mkpath
    Rack.new(HOMEBREW_CELLAR.realpath/name.to_s)
  end

  # An array of all existing (i.e. `real?`==true) racks.
  def self.all
    if HOMEBREW_CELLAR.exist?
      HOMEBREW_CELLAR.children.map do |d|
        begin
          Rack.new(d)
        rescue RuntimeError
          nil
        end
      end.compact.select{ |r| r.real? rescue false }
    else
      []
    end
  end

  def fname
    File.basename(@path).to_s
  end

  def self.all_fnames
    Rack.all.map{ |r| r.fname }
  end

  # Get the formula, based on the fname. FIXME: This will not return formulae from taps if shadowed by another
  def formula
    require 'formula'
    Formula.factory(fname)
  end

  # keg_only formulae can only be linked with brew link --force <formula>
  def self.linked_but_keg_only
    Rack.all.select do |r|
      begin
        f = r.formula
        f.keg_only? && f.linked_keg.directory?
      rescue
        false
      end
    end
  end

  # Normally, only keg_only formulae are unlinked
  def self.unlinked_but_not_keg_only
    Rack.all.select do |r|
      begin
        f = r.formula
        r.real? && !f.keg_only? && !f.linked_keg.directory?
      rescue
        false
      end
    end
  end

  def to_s
    @path.to_s
  end

  # A Rack is defined by it's path
  def == other
    @path == other.path
  end

  alias to_str to_s  # for ruby < 1.9

end
