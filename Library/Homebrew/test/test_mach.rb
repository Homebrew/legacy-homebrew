require 'testing_env'

module FileHelper
  def file pn
    `/usr/bin/file -h '#{pn}'`.chomp
  end
end

class MachOPathnameTests < Test::Unit::TestCase
  include FileHelper

  def setup
    @archs = [:i386, :x86_64, :ppc7400, :ppc64].extend(ArchitectureListExtension)
  end

  def test_fat_dylib
    pn = Pathname.new("#{TEST_FOLDER}/mach/fat.dylib")
    assert pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert pn.arch == :universal
    assert_match(/Mach-O (64-bit )?dynamically linked shared library/, file(pn))
  end

  def test_i386_dylib
    pn = Pathname.new("#{TEST_FOLDER}/mach/i386.dylib")
    assert !pn.universal?
    assert pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert !pn.mach_o_bundle?
    assert_match(/Mach-O dynamically linked shared library/, file(pn))
  end

  def test_x86_64_dylib
    pn = Pathname.new("#{TEST_FOLDER}/mach/x86_64.dylib")
    assert !pn.universal?
    assert !pn.i386?
    assert pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert !pn.mach_o_bundle?
    assert_match(/Mach-O 64-bit dynamically linked shared library/, file(pn))
  end

  def test_mach_o_executable
    pn = Pathname.new("#{TEST_FOLDER}/mach/a.out")
    assert pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert pn.mach_o_executable?
    assert !pn.text_executable?
    assert !pn.mach_o_bundle?
    assert_match(/Mach-O (64-bit )?executable/, file(pn))
  end

  def test_fat_bundle
    pn = Pathname.new("#{TEST_FOLDER}/mach/fat.bundle")
    assert pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert pn.mach_o_bundle?
    assert_match(/Mach-O (64-bit )?bundle/, file(pn))
  end

  def test_i386_bundle
    pn = Pathname.new("#{TEST_FOLDER}/mach/i386.bundle")
    assert !pn.universal?
    assert pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert pn.mach_o_bundle?
    assert_match(/Mach-O bundle/, file(pn))
  end

  def test_x86_64_bundle
    pn = Pathname.new("#{TEST_FOLDER}/mach/x86_64.bundle")
    assert !pn.universal?
    assert !pn.i386?
    assert pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert pn.mach_o_bundle?
    assert_match(/Mach-O 64-bit bundle/, file(pn))
  end

  def test_non_mach_o
    pn = Pathname.new("#{TEST_FOLDER}/tarballs/testball-0.1.tbz")
    assert !pn.universal?
    assert !pn.i386?
    assert !pn.x86_64?
    assert !pn.ppc7400?
    assert !pn.ppc64?
    assert !pn.dylib?
    assert !pn.mach_o_executable?
    assert !pn.text_executable?
    assert !pn.mach_o_bundle?
    assert pn.arch == :dunno
    assert_no_match(/Mach-O (64-bit )?dynamically linked shared library/, file(pn))
    assert_no_match(/Mach-O [^ ]* ?executable/, file(pn))
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
    pn = Pathname.new("#{TEST_FOLDER}/mach/fat.dylib")
    assert pn.archs.intel_universal?
    assert_equal "-arch x86_64 -arch i386", pn.archs.as_arch_flags
    assert_equal "x86_64;i386", pn.archs.as_cmake_arch_flags
  end
end

class TextExecutableTests < Test::Unit::TestCase
  include FileHelper

  def teardown
    (HOMEBREW_PREFIX/'foo_script').unlink
  end

  def test_simple_shebang
    pn = HOMEBREW_PREFIX/'foo_script'
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
    assert pn.arch == :dunno
    assert_match(/text executable/, file(pn))
  end

  def test_shebang_with_options
    pn = HOMEBREW_PREFIX/'foo_script'
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
    assert pn.arch == :dunno
    assert_match(/text executable/, file(pn))
  end

  def test_malformed_shebang
    pn = HOMEBREW_PREFIX/'foo_script'
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
    assert pn.arch == :dunno
    assert_no_match(/text executable/, file(pn))
  end
end
