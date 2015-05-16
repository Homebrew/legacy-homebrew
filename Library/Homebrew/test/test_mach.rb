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
    assert_predicate pn, :universal?
    refute_predicate pn, :i386?
    refute_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    assert_predicate pn, :dylib?
    refute_predicate pn, :mach_o_executable?
    refute_predicate pn, :text_executable?
    assert_equal :universal, pn.arch
  end

  def test_i386_dylib
    pn = dylib_path("i386")
    refute_predicate pn, :universal?
    assert_predicate pn, :i386?
    refute_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    assert_predicate pn, :dylib?
    refute_predicate pn, :mach_o_executable?
    refute_predicate pn, :text_executable?
    refute_predicate pn, :mach_o_bundle?
  end

  def test_x86_64_dylib
    pn = dylib_path("x86_64")
    refute_predicate pn, :universal?
    refute_predicate pn, :i386?
    assert_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    assert_predicate pn, :dylib?
    refute_predicate pn, :mach_o_executable?
    refute_predicate pn, :text_executable?
    refute_predicate pn, :mach_o_bundle?
  end

  def test_mach_o_executable
    pn = Pathname.new("#{TEST_DIRECTORY}/mach/a.out")
    assert_predicate pn, :universal?
    refute_predicate pn, :i386?
    refute_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    refute_predicate pn, :dylib?
    assert_predicate pn, :mach_o_executable?
    refute_predicate pn, :text_executable?
    refute_predicate pn, :mach_o_bundle?
  end

  def test_fat_bundle
    pn = bundle_path("fat")
    assert_predicate pn, :universal?
    refute_predicate pn, :i386?
    refute_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    refute_predicate pn, :dylib?
    refute_predicate pn, :mach_o_executable?
    refute_predicate pn, :text_executable?
    assert_predicate pn, :mach_o_bundle?
  end

  def test_i386_bundle
    pn = bundle_path("i386")
    refute_predicate pn, :universal?
    assert_predicate pn, :i386?
    refute_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    refute_predicate pn, :dylib?
    refute_predicate pn, :mach_o_executable?
    refute_predicate pn, :text_executable?
    assert_predicate pn, :mach_o_bundle?
  end

  def test_x86_64_bundle
    pn = bundle_path("x86_64")
    refute_predicate pn, :universal?
    refute_predicate pn, :i386?
    assert_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    refute_predicate pn, :dylib?
    refute_predicate pn, :mach_o_executable?
    refute_predicate pn, :text_executable?
    assert_predicate pn, :mach_o_bundle?
  end

  def test_non_mach_o
    pn = Pathname.new("#{TEST_DIRECTORY}/tarballs/testball-0.1.tbz")
    refute_predicate pn, :universal?
    refute_predicate pn, :i386?
    refute_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    refute_predicate pn, :dylib?
    refute_predicate pn, :mach_o_executable?
    refute_predicate pn, :text_executable?
    refute_predicate pn, :mach_o_bundle?
    assert_equal :dunno, pn.arch
  end
end

class ArchitectureListExtensionTests < MachOPathnameTests
  def setup
    @archs = [:i386, :x86_64, :ppc7400, :ppc64].extend(ArchitectureListExtension)
  end

  def test_architecture_list_extension_universal_checks
    assert_predicate @archs, :universal?
    assert_predicate @archs, :intel_universal?
    assert_predicate @archs, :ppc_universal?
    assert_predicate @archs, :cross_universal?
    assert_predicate @archs, :fat?

    non_universal = [:i386].extend ArchitectureListExtension
    refute_predicate non_universal, :universal?

    intel_only = [:i386, :x86_64].extend ArchitectureListExtension
    assert_predicate intel_only, :universal?
    refute_predicate intel_only, :ppc_universal?
    refute_predicate intel_only, :cross_universal?

    ppc_only = [:ppc970, :ppc64].extend ArchitectureListExtension
    assert_predicate ppc_only, :universal?
    refute_predicate ppc_only, :intel_universal?
    refute_predicate ppc_only, :cross_universal?

    cross = [:ppc7400, :i386].extend ArchitectureListExtension
    assert_predicate cross, :universal?
    refute_predicate cross, :intel_universal?
    refute_predicate cross, :ppc_universal?
  end

  def test_architecture_list_extension_massaging_flags
    @archs.remove_ppc!
    assert_equal 2, @archs.length
    assert_match(/-arch i386/, @archs.as_arch_flags)
    assert_match(/-arch x86_64/, @archs.as_arch_flags)
  end

  def test_architecture_list_arch_flags_methods
    pn = dylib_path("fat")
    assert_predicate pn.archs, :intel_universal?
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
    refute_predicate pn, :universal?
    refute_predicate pn, :i386?
    refute_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    refute_predicate pn, :dylib?
    refute_predicate pn, :mach_o_executable?
    assert_predicate pn, :text_executable?
    assert_equal [], pn.archs
    assert_equal :dunno, pn.arch
  end

  def test_shebang_with_options
    pn.write '#! /usr/bin/perl -w'
    refute_predicate pn, :universal?
    refute_predicate pn, :i386?
    refute_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    refute_predicate pn, :dylib?
    refute_predicate pn, :mach_o_executable?
    assert_predicate pn, :text_executable?
    assert_equal [], pn.archs
    assert_equal :dunno, pn.arch
  end

  def test_malformed_shebang
    pn.write ' #!'
    refute_predicate pn, :universal?
    refute_predicate pn, :i386?
    refute_predicate pn, :x86_64?
    refute_predicate pn, :ppc7400?
    refute_predicate pn, :ppc64?
    refute_predicate pn, :dylib?
    refute_predicate pn, :mach_o_executable?
    refute_predicate pn, :text_executable?
    assert_equal [], pn.archs
    assert_equal :dunno, pn.arch
  end
end
