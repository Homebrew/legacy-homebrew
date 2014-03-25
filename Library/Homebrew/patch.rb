require 'resource'
require 'stringio'
require 'erb'

class Patch
  def self.create(strip, io=nil, &block)
    case strip ||= :p1
    when :DATA, IO, StringIO
      IOPatch.new(strip, :p1)
    when String
      IOPatch.new(StringIO.new(strip), :p1)
    when Symbol
      case io
      when :DATA, IO, StringIO
        IOPatch.new(io, strip)
      when String
        IOPatch.new(StringIO.new(io), strip)
      else
        ExternalPatch.new(strip, &block)
      end
    else
      raise ArgumentError, "unexpected value #{strip.inspect} for strip"
    end
  end

  def self.normalize_legacy_patches(list)
    patches = []

    case list
    when Hash
      list
    when Array, String, IO, StringIO
      { :p1 => list }
    else
      {}
    end.each_pair do |strip, urls|
      urls = [urls] unless Array === urls
      urls.each do |url|
        case url
        when IO, StringIO
          patch = IOPatch.new(url, strip)
        else
          patch = LegacyPatch.new(strip, url)
        end
        patches << patch
      end
    end

    patches
  end

  attr_reader :whence

  def external?
    whence == :resource
  end
end

class IOPatch < Patch
  attr_writer :owner
  attr_reader :strip

  def initialize(io, strip)
    @io     = io
    @strip  = strip
    @whence = :io
  end

  def apply
    @io = DATA if @io == :DATA
    data = @io.read
    data.gsub!("HOMEBREW_PREFIX", HOMEBREW_PREFIX)
    IO.popen("/usr/bin/patch -g 0 -f -#{strip}", "w") { |p| p.write(data) }
    raise ErrorDuringExecution, "Applying DATA patch failed" unless $?.success?
  ensure
    # IO and StringIO cannot be marshaled, so remove the reference
    # in case we are indirectly referenced by an exception later.
    @io = nil
  end

  def inspect
    "#<#{self.class}: #{strip.inspect}>"
  end
end

class ExternalPatch < Patch
  attr_reader :resource, :strip

  def initialize(strip, &block)
    @strip    = strip
    @resource = Resource.new("patch", &block)
    @whence   = :resource
  end

  def owner= owner
    resource.owner   = owner
    resource.version = resource.checksum || ERB::Util.url_encode(resource.url)
  end

  def apply
    dir = Pathname.pwd
    resource.unpack do
      # Assumption: the only file in the staging directory is the patch
      patchfile = Pathname.pwd.children.first
      safe_system "/usr/bin/patch", "-g", "0", "-f", "-d", dir, "-#{strip}", "-i", patchfile
    end
  end

  def url
    resource.url
  end

  def fetch
    resource.fetch
  end

  def verify_download_integrity(fn)
    resource.verify_download_integrity(fn)
  end

  def cached_download
    resource.cached_download
  end

  def clear_cache
    resource.clear_cache
  end

  def inspect
    "#<#{self.class}: #{strip.inspect} #{url.inspect}>"
  end
end

# Legacy patches have no checksum and are not cached
class LegacyPatch < ExternalPatch
  def initialize(strip, url)
    super(strip)
    resource.url = url
    resource.download_strategy = CurlDownloadStrategy
  end

  def fetch
    clear_cache
    super
  end

  def verify_download_integrity(fn)
    # no-op
  end

  def apply
    super
  ensure
    clear_cache
  end
end
