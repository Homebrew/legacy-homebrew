require 'formula'

# Downloads the tarballs for the given formulae to the Cache

module Homebrew extend self
  def fetch
    ARGV.formulae.each do |f|
      if ARGV.include? "--force" or ARGV.include? "-f"
        where_to = `brew --cache #{f.name}`.strip
        FileUtils.rm_rf where_to unless where_to.empty?
      end

      the_tarball = f.downloader.fetch
      next unless the_tarball.kind_of? Pathname

      previous_md5 = f.instance_variable_get(:@md5)
      previous_sha1 = f.instance_variable_get(:@sha1)

      puts "MD5:  #{the_tarball.md5}"
      puts "SHA1: #{the_tarball.sha1}"

      unless previous_md5.nil? or previous_md5.empty? or  the_tarball.md5 == previous_md5
        opoo "Formula reports different MD5: #{previous_md5}"
      end
      unless previous_sha1.nil? or previous_sha1.empty? or the_tarball.sha1 == previous_sha1
        opoo "Formula reports different SHA1: #{previous_sha1}"
      end
    end
  end
end
