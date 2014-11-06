# -*- ruby -*-

require "rubygems"
require "hoe"
require "oedipus_lex"

# Hoe.plugin :compiler
# Hoe.plugin :email
# Hoe.plugin :gem_prelude_sucks
# Hoe.plugin :history
# Hoe.plugin :inline
Hoe.plugin :minitest
# Hoe.plugin :perforce
# Hoe.plugin :racc
# Hoe.plugin :rcov
# Hoe.plugin :rdoc
# Hoe.plugin :rubygems
# Hoe.plugin :seattlerb
# Hoe.plugin :travis

Hoe.spec "praat_lex" do
  developer "Andrew Smith", "andrewchristophersmith@gmail.com"
  dependency "oedipus_lex", "~> 2.4", :developer

  self.group_name = "Andrew Smith" # if part of an organization/group

  license "MIT" # this should match the license in the README
end

Rake.application.rake_require "oedipus_lex"
task :lexer => "lib/praat_lexer.rex.rb"
task :parser => :lexer
task :test => :parser

file "lib/praat_lexer.rex.rb" => "lib/praat_lexer.rex"

# vim: syntax=ruby
