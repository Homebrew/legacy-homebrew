require 'cmd/install'

module Homebrew extend self
  def reinstall
    # At first save the named formulae and remove them from ARGV
    named = ARGV.named
    ARGV.delete_if { |arg| named.include? arg }
    clean_ARGV = ARGV.clone

    # Add the used_options for each named formula separately so
    # that the options apply to the right formula.
    named.each do |name|
      ARGV.replace(clean_ARGV)
      ARGV << name
      tab = Tab.for_name(name)
      tab.used_options.each { |option| ARGV << option.to_s }
      if tab.built_as_bottle and not tab.poured_from_bottle
        ARGV << '--build-bottle'
      end

      canonical_name = Formula.canonical_name(name)
      formula = Formula.factory(canonical_name)

      begin
        oh1 "Reinstalling #{name} #{ARGV.options_only*' '}"
        opt_link = HOMEBREW_PREFIX/'opt'/canonical_name
        if opt_link.exist?
          keg = Keg.new(opt_link.realpath)
          backup keg
        end
        self.install_formula formula
      rescue Exception => e
        ofail e.message unless e.message.empty?
        restore_backup keg, formula
        raise 'Reinstall failed.'
      else
        backup_path(keg).rmtree if backup_path(keg).exist?
      end
    end
  end

  def backup keg
    keg.unlink
    keg.rename backup_path(keg)
  end

  def restore_backup keg, formula
    path = backup_path(keg)
    if path.directory?
      path.rename keg
      keg.link unless formula.keg_only?
    end
  end

  def backup_path path
    Pathname.new "#{path}.reinstall"
  end
end
