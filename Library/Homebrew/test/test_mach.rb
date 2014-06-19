require 'testing_env'

class MachOPathnameTests < Homebrew::TestCase
  def dylib_path(name)
    Pathname.new("#{TEST_DIRECTORY}/mach/#{name}.dylib")
  end

  def bundle_path(name)
    Pathname.new("#{TEST_DIRECTORY}/mach/#{name}.bundle")
  end

  def test_fat_dylib
    pn = dylib_path("fat")
    assert pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert_equal :universal, pn.arch
  end

  def test_i386_dylib
    pn = dylib_path("i386")
    assert !pn.universal?
    assert pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert !pn.mach_o_bundle?
  end

  def test_x86_64_dylib
    pn = dylib_path("x86_64")
    assert !pn.universal?
    assert !pn.i386?
    assert pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert !pn.mach_o_bundle?
  end

  def test_mach_o_executable
    pn = Pathname.new("#{TEST_DIRECTORY}/mach/a.out")
    assert pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert pn.mach_o_executable?
    assert !pn.text_executable?
    assert !pn.mach_o_bundle?
  end

  def test_fat_bundle
    pn = bundle_path("fat")
    assert pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert pn.mach_o_bundle?
  end

  def test_i386_bundle
    pn = bundle_path("i386")
    assert !pn.universal?
    assert pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert pn.mach_o_bundle?
  end

  def test_x86_64_bundle
    pn = bundle_path("x86_64")
    assert !pn.universal?
    assert !pn.i386?
    assert pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert pn.mach_o_bundle?
  end

  def test_non_mach_o
    pn = Pathname.new("#{TEST_DIRECTORY}/tarballs/testball-0.1.tbz")
    assert !pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert !pn.mach_o_bundle?
    assert_equal :dunno, pn.arch
  end
end

class ArchitectureListExtensionTests < MachOPathnameTests
  def setup
    @archs = [:i386, :x86_64, :ppc7400, :ppc64].extend(ArchitectureListExtension)
  end

  def test_architecture_list_extension_universal_checks
    assert @archs.universal?
    assert @archs.intel_universal?
    assert @archs.ppc_universal?
    assert @archs.cross_universal?
    assert @archs.fat?

    non_universal = [:i386].extend ArchitectureListExtension
    assert !non_universal.universal?

    intel_only = [:i386, :x86_64].extend ArchitectureListExtension
    assert intel_only.universal?
    assert !intel_only.ppc_universal?
    assert !intel_only.cross_universal?

    ppc_only = [:ppc970, :ppc64].extend ArchitectureListExtension
    assert ppc_only.universal?
    assert !ppc_only.intel_universal?
    assert !ppc_only.cross_universal?

    cross = [:ppc7400, :i386].extend ArchitectureListExtension
    assert cross.universal?
    assert !cross.intel_universal?
    assert !cross.ppc_universal?
  end

  def test_architecture_list_extension_massaging_flags
    @archs.remove_ppc!
    assert_equal 2, @archs.length
    assert_match(/-arch i386/, @archs.as_arch_flags)
    assert_match(/-arch x86_64/, @archs.as_arch_flags)
  end

  def test_architecture_list_arch_flags_methods
    pn = dylib_path("fat")
    assert pn.archs.intel_universal?
    assert_equal "-arch x86_64 -arch i386", pn.archs.as_arch_flags
    assert_equal "x86_64;i386", pn.archs.as_cmake_arch_flags
  end
end

class TextExecutableTests < Homebrew::TestCase
  attr_reader :pn

  def setup
    @pn = HOMEBREW_PREFIX.join("an_executable")
  end

  def teardown
    HOMEBREW_PREFIX.join("an_executable").unlink
  end

  def test_simple_shebang
    pn.write '#!/bin/sh'
    assert !pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert pn.text_executable?
    assert_equal [], pn.archs
    assert_equal :dunno, pn.arch
  end

  def test_shebang_with_options
    pn.write '#! /usr/bin/perl -w'
    assert !pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert pn.text_executable?
    assert_equal [], pn.archs
    assert_equal :dunno, pn.arch
  end

  def test_malformed_shebang
    pn.write ' #!'
    assert !pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert_equal [], pn.archs
    assert_equal :dunno, pn.arch
  end
end
