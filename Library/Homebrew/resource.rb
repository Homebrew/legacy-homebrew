# A Resource describes a tarball that a formula needs in addition
# to the formula's own download.
class Resource
  include FileUtils

  # The mktmp mixin expects a name property
  # This is the resource name
  attr_reader :name

  def initialize name, spec
    @name = name
    @spec = spec
  end

  # Formula name must be set after the DSL, as we have no access to the
  # formula name before initialization of the formula
  def set_owner owner
    @owner = owner
    @downloader = @spec.download_strategy.new("#{owner}--#{name}", @spec)
  end

  # Download the resource
  # If a target is given, unpack there; else unpack to a temp folder
  # If block is given, yield to that block
  # A target or a block must be given, but not both
  def stage(target=nil)
    fetched = fetch
    verify_download_integrity(fetched) if fetched.respond_to?(:file?) and fetched.file?
    mktemp do
      @downloader.stage
      if block_given?
        yield self
      else
        target.install Dir['*']
      end
    end
  end

  def cached_download
    @downloader.cached_location
  end

  # For brew-fetch and others.
  def fetch
    # Ensure the cache exists
    HOMEBREW_CACHE.mkpath
    @downloader.fetch
    cached_download
  end

  def verify_download_integrity fn
    @spec.verify_download_integrity(fn)
  end
end
