module FormulaCompat
  def x11_installed?
    MacOS::X11.installed?
  end

  def snow_leopard_64?
    MacOS.prefer_64_bit?
  end
end

class Formula
  include FormulaCompat
  extend FormulaCompat

  def std_cmake_parameters
    "-DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=None -DCMAKE_FIND_FRAMEWORK=LAST -Wno-dev"
  end

  def cxxstdlib
    self.class.cxxstdlib
  end

  def cxxstdlib_check check_type
    self.class.cxxstdlib_check check_type
  end

  def self.bottle_sha1(*)
  end

  def self.all
    opoo "Formula.all is deprecated, use Formula.map instead"
    map
  end

  def self.canonical_name(name)
    Formulary.canonical_name(name)
  end

  def self.class_s(name)
    Formulary.class_s(name)
  end

  def self.factory(name)
    Formulary.factory(name)
  end
end
