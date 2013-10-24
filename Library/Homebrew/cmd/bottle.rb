require 'formula'
require 'bottles'
require 'tab'
require 'keg'
require 'cmd/versions'
require 'utils/inreplace'
require 'erb'

class BottleMerger < Formula
  # This provides a URL and Version which are the only needed properties of
  # a Formula. This object is used to access the Formula bottle DSL to merge
  # multiple outputs of `brew bottle`.
  url '1'
  def self.reset_bottle; @bottle = Bottle.new; end
end

BOTTLE_ERB = <<-EOS
  bottle do
    <% if prefix.to_s != '/usr/local' %>
    prefix '<%= prefix %>'
    <% end %>
    <% if cellar.is_a? Symbol %>
    cellar :<%= cellar %>
    <% elsif cellar.to_s != '/usr/local/Cellar' %>
    cellar '<%= cellar %>'
    <% end %>
    <% if revision > 0 %>
    revision <%= revision %>
    <% end %>
    <% checksums.each do |checksum_type, checksum_values| %>
    <% checksum_values.each do |checksum_value| %>
    <% checksum, osx = checksum_value.shift %>
    <%= checksum_type %> '<%= checksum %>' => :<%= osx %>
    <% end %>
    <% end %>
  end
EOS

module Homebrew extend self
  class << self
    include Utils::Inreplace
  end

  def keg_contains string, keg
    quiet_system 'fgrep', '--recursive', '--quiet', '--max-count=1', string, keg
  end

  def bottle_output bottle
    erb = ERB.new BOTTLE_ERB
    erb.result(bottle.instance_eval { binding }).gsub(/^\s*$\n/, '')
  end

  def bottle_formula f
    unless f.installed?
      return ofail "Formula not installed: #{f.name}"
    end

    unless built_as_bottle? f
      return ofail "Formula not installed with '--build-bottle': #{f.name}"
    end

    master_bottle_filenames = f.bottle_filenames 'origin/master'
    bottle_revision = -1
    begin
      bottle_revision += 1
      filename = bottle_filename(f, bottle_revision)
    end while not ARGV.include? '--no-revision' \
        and master_bottle_filenames.include? filename

    if bottle_filename_formula_name(filename).empty?
      return ofail "Add a new regex to bottle_version.rb to parse the bottle filename."
    end

    bottle_path = Pathname.pwd/filename
    sha1 = nil

    prefix = HOMEBREW_PREFIX.to_s
    tmp_prefix = '/tmp'
    cellar = HOMEBREW_CELLAR.to_s
    tmp_cellar = '/tmp/Cellar'

    output = nil

    HOMEBREW_CELLAR.cd do
      ohai "Bottling #{filename}..."
      # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
      # or an uncompressed tarball (and more bandwidth friendly).
      safe_system 'tar', 'czf', bottle_path, "#{f.name}/#{f.version}"
      sha1 = bottle_path.sha1
      relocatable = false

      if File.size?(bottle_path) > 1*1024*1024
        ohai "Detecting if #{filename} is relocatable..."
      end
      keg = Keg.new f.prefix
      keg.lock do
        # Relocate bottle library references before testing for built-in
        # references to the Cellar e.g. Qt's QMake annoyingly does this.
        keg.relocate_install_names prefix, tmp_prefix, cellar, tmp_cellar, :keg_only => f.keg_only?

        if prefix == '/usr/local'
          prefix_check = HOMEBREW_PREFIX/'opt'
        else
          prefix_check = HOMEBREW_PREFIX
        end

        relocatable = !keg_contains(prefix_check, keg)
        relocatable = !keg_contains(HOMEBREW_CELLAR, keg) if relocatable

        # And do the same thing in reverse to change the library references
        # back to how they were.
        keg.relocate_install_names tmp_prefix, prefix, tmp_cellar, cellar
      end

      bottle = Bottle.new
      bottle.prefix HOMEBREW_PREFIX
      bottle.cellar relocatable ? :any : HOMEBREW_CELLAR
      bottle.revision bottle_revision
      bottle.sha1 sha1 => bottle_tag

      puts "./#{filename}"
      output = bottle_output bottle
      puts output
    end

    if ARGV.include? '--rb'
      bottle_base = filename.gsub(bottle_suffix(bottle_revision), '')
      File.open "#{bottle_base}.bottle.rb", 'w' do |file|
        file.write output
      end
    end
  end

  def merge
    merge_hash = {}
    ARGV.named.each do |argument|
      formula_name = bottle_filename_formula_name argument
      merge_hash[formula_name] ||= []
      bottle_block = IO.read argument
      merge_hash[formula_name] << bottle_block
    end
    merge_hash.keys.each do |formula_name|
      BottleMerger.reset_bottle
      ohai formula_name
      bottle_blocks = merge_hash[formula_name]
      bottle_blocks.each do |bottle_block|
        BottleMerger.class_eval bottle_block
      end
      bottle = BottleMerger.new.bottle
      next unless bottle
      output = bottle_output bottle
      puts output

      if ARGV.include? '--write'
        f = Formula.factory formula_name
        formula_path = HOMEBREW_REPOSITORY+"Library/Formula/#{f.name}.rb"
        inreplace formula_path do |s|
          if f.bottle
            s.gsub!(/  bottle do.+?end\n/m, output)
          else
            s.gsub!(/(  (url|sha1|head|version) '\S*'\n+)+/m, '\0' + output + "\n")
          end
        end

        update_or_add = f.bottle.nil? ? 'add' : 'update'

        safe_system 'git', 'commit', formula_path, '-m',
          "#{f.name}: #{update_or_add} bottle."
      end
    end
    exit 0
  end

  def bottle
    merge if ARGV.include? '--merge'

    ARGV.formulae.each do |f|
      bottle_formula f
    end
  end
end
