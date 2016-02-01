require "resource"
require "erb"

module Patch
  def self.create(strip, src, &block)
    case strip
    when :DATA
      DATAPatch.new(:p1)
    when String
      StringPatch.new(:p1, strip)
    when Symbol
      case src
      when :DATA
        DATAPatch.new(strip)
      when String
        StringPatch.new(strip, src)
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
    when Array, String, :DATA
      { :p1 => list }
    else
      {}
    end.each_pair do |strip, urls|
      Array(urls).each do |url|
        case url
        when :DATA
          patch = DATAPatch.new(strip)
        else
          patch = LegacyPatch.new(strip, url)
        end
        patches << patch
      end
    end

    patches
  end
end

class EmbeddedPatch
  attr_writer :owner
  attr_reader :strip

  def initialize(strip)
    @strip = strip
  end

  def external?
    false
  end

  def contents
  end

  def apply
    data = contents.gsub("HOMEBREW_PREFIX", HOMEBREW_PREFIX)
    cmd = "/usr/bin/patch"
    args = %W[-g 0 -f -#{strip}]
    IO.popen("#{cmd} #{args.join(" ")}", "w") { |p| p.write(data) }
    raise ErrorDuringExecution.new(cmd, args) unless $?.success?
  end

  def inspect
    "#<#{self.class.name}: #{strip.inspect}>"
  end
end

class DATAPatch < EmbeddedPatch
  attr_accessor :path

  def initialize(strip)
    super
    @path = nil
  end

  def contents
    data = ""
    path.open("rb") do |f|
      begin
        line = f.gets
      end until line.nil? || /^__END__$/ === line
      data << line while line = f.gets
    end
    data
  end
end

class StringPatch < EmbeddedPatch
  def initialize(strip, str)
    super(strip)
    @str = str
  end

  def contents
    @str
  end
end

class ExternalPatch
  attr_reader :resource, :strip

  def initialize(strip, &block)
    @strip    = strip
    @resource = Resource::Patch.new(&block)
  end

  def external?
    true
  end

  def owner=(owner)
    resource.owner   = owner
    resource.version = resource.checksum || ERB::Util.url_encode(resource.url)
  end

  def apply
    dir = Pathname.pwd
    resource.unpack do
      patch_dir = Pathname.pwd
      if patch_files.empty?
        children = patch_dir.children
        if (children.count == 1 && children.first.file?)
          patch_files << children.first.basename
        else
          raise MissingApplyError, <<-EOS.undent
            There should be exactly one patch file in the staging directory unless
            the "apply" method was used one or more times in the patch-do block.
          EOS
        end
      end
      dir.cd do
        patch_files.each do |patch_file|
          ohai "Applying #{patch_file}"
          patch_file = patch_dir/patch_file
          safe_system "/usr/bin/patch", "-g", "0", "-f", "-#{strip}", "-i", patch_file
        end
      end
    end
  end

  def url
    resource.url
  end

  def fetch
    resource.fetch
  end

  def patch_files
    resource.patch_files
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
    "#<#{self.class.name}: #{strip.inspect} #{url.inspect}>"
  end
end

# Legacy patches have no checksum and are not cached
class LegacyPatch < ExternalPatch
  def initialize(strip, url)
    super(strip)
    resource.url(url)
    resource.download_strategy = CurlDownloadStrategy
  end

  def fetch
    clear_cache
    super
  end

  def verify_download_integrity(_fn)
    # no-op
  end

  def apply
    super
  ensure
    clear_cache
  end
end
