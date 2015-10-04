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

  def cxxstdlib_check(check_type)
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

  def self.require_universal_deps
    define_method(:require_universal_deps?) { true }
  end

  def self.path(name)
    Formulary.core_path(name)
  end

  DATA = :DATA

  def patches
    {}
  end

  def python(_options = {}, &block)
    opoo "Formula#python is deprecated and will go away shortly."
    block.call if block_given?
    PythonRequirement.new
  end
  alias_method :python2, :python
  alias_method :python3, :python
end
