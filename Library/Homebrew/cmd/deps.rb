require 'formula'
require 'ostruct'

module Homebrew extend self
  def deps
    mode = OpenStruct.new(
      :installed?  => ARGV.include?('--installed'),
      :tree?       => ARGV.include?('--tree'),
      :all?        => ARGV.include?('--all'),
      :topo_order? => ARGV.include?('-n')
    )

    if mode.installed? && mode.tree?
      puts_deps_tree Formula.installed
    elsif mode.installed?
      puts_deps Formula.installed
    elsif mode.all?
      puts_deps Formula
    elsif mode.tree?
      raise FormulaUnspecifiedError if ARGV.named.empty?
      puts_deps_tree ARGV.formulae
    else
      raise FormulaUnspecifiedError if ARGV.named.empty?
      all_deps = deps_for_formulae(ARGV.formulae, !ARGV.one?)
      all_deps.sort! unless mode.topo_order?
      puts all_deps
    end
  end

  def deps_for_formula(f, recursive=false)
    if recursive
      deps = f.recursive_dependencies
      reqs = f.recursive_requirements
    else
      deps = f.deps.default
      reqs = f.requirements
    end
    deps.map(&:name) + reqs.to_a.map do |r|
      r.class.default_formula if r.default_formula?
    end.compact
  end

  def deps_for_formulae(formulae, recursive=false)
    formulae.map {|f| deps_for_formula(f, recursive) }.inject(&:&)
  end

  def puts_deps(formulae)
    formulae.each { |f| puts "#{f.name}: #{deps_for_formula(f)*' '}" }
  end

  def puts_deps_tree(formulae)
    formulae.each do |f|
      puts f.name
      recursive_deps_tree(f, 1)
      puts
    end
  end

  def recursive_deps_tree f, level
    f.requirements.each do |requirement|
      next unless requirement.default_formula?
      puts "|  "*(level-1)+"|- :"+requirement.class.default_formula.to_s
    end
    f.deps.default.each do |dep|
      puts "|  "*(level-1)+"|- "+dep.to_s
      recursive_deps_tree(Formula.factory(dep.to_s), level+1)
    end
  end
end
