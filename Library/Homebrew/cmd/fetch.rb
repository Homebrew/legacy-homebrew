require 'formula'

module Homebrew
  def fetch
    raise FormulaUnspecifiedError if ARGV.named.empty?

    if ARGV.include? '--deps'
      bucket = []
      ARGV.formulae.each do |f|
        bucket << f
        bucket.concat f.recursive_dependencies.map(&:to_formula)
      end
      bucket.uniq!
    else
      bucket = ARGV.formulae
    end

    puts "Fetching: #{bucket * ', '}" if bucket.size > 1
    bucket.each do |f|
      if fetch_bottle?(f)
        fetch_formula(f.bottle)
      else
        fetch_formula(f)
        f.resources.each { |r| fetch_resource(r) }
        f.patchlist.select(&:external?).each { |p| fetch_patch(p) }
      end
    end
  end

  def fetch_bottle? f
    return true if ARGV.force_bottle? && f.bottle
    return false unless f.bottle && f.pour_bottle?
    return false if ARGV.build_from_source? || ARGV.build_bottle?
    return false unless f.bottle.compatible_cellar?
    return true
  end

  def fetch_resource r
    puts "Resource: #{r.name}"
    fetch_fetchable r
  rescue ChecksumMismatchError => e
    retry if retry_fetch? r
    opoo "Resource #{r.name} reports different #{e.hash_type}: #{e.expected}"
  end

  def fetch_formula f
    fetch_fetchable f
  rescue ChecksumMismatchError => e
    retry if retry_fetch? f
    opoo "Formula reports different #{e.hash_type}: #{e.expected}"
  end

  def fetch_patch p
    fetch_fetchable p
  rescue ChecksumMismatchError => e
    Homebrew.failed = true
    opoo "Patch reports different #{e.hash_type}: #{e.expected}"
  end

  private

  def retry_fetch? f
    @fetch_failed ||= {}
    already_failed = @fetch_failed.fetch(f.name, false)

    if already_failed || !ARGV.include?("--retry")
      Homebrew.failed = true
      return false
    end

    f.clear_cache
    @fetch_failed[f.name] = true
    true
  end

  def fetch_fetchable f
    f.clear_cache if ARGV.force?

    already_fetched = f.cached_download.exist?
    download = f.fetch

    return unless download.file?

    puts "Downloaded to: #{download}" unless already_fetched
    puts Checksum::TYPES.map { |t| "#{t.to_s.upcase}: #{download.send(t)}" }

    f.verify_download_integrity(download)
  end
end
