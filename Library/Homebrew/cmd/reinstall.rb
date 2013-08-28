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

      if not formula.installed?
        if force_new_install?
          oh1 "Force installing new formula: #{name}"
          self.install_formula formula
          next
        else
          raise <<-EOS.undent
          #{formula} is not installed. Please install it first or use
          "--force-new-install" flag.
          EOS
        end
      end

      linked_keg_ref = HOMEBREW_REPOSITORY/'opt'/canonical_name
      keg = Keg.new(linked_keg_ref.realpath)

      begin
        oh1 "Reinstalling #{name} #{ARGV.options_only*' '}"
        quarantine keg
        self.install_formula formula
      rescue Exception => e
        ofail e.message unless e.message.empty?
        restore_quarantine keg, formula
        raise 'Reinstallation abort.'
      else
        remove_quarantine keg
      end
    end
  end

  def force_new_install?
    ARGV.include? '--force-new-install'
  end

  def quarantine keg
    keg.unlink

    path = Pathname.new(keg.to_s)
    path.rename quarantine_path(path)
  end

  def restore_quarantine keg, formula
    path = Pathname.new(quarantine_path(keg))
    if path.directory?
      path.rename keg.to_s
      keg.link unless formula.keg_only?
    end
  end

  def remove_quarantine keg
    path = Pathname.new(quarantine_path(keg))
    path.rmtree
  end

  def quarantine_path path
    path.to_s + '.reinstall'
  end
end
