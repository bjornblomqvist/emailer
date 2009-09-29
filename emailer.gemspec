# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{emailer}
  s.version = "0.1.16"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Erik Hansson", "Bjorn Blomqvist"]
  s.date = %q{2009-09-29}
  s.description = %q{}
  s.email = %q{erik@bits2life.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "emailer.gemspec",
     "lib/emailer.rb",
     "lib/emailer/authsmtp_facade.rb",
     "lib/emailer/logger_smtp_facade.rb",
     "lib/emailer/mail_queue.rb",
     "lib/emailer/mock_smtp_facade.rb",
     "lib/emailer/smtp_facade.rb",
     "lib/emailer/string_utilities.rb",
     "lib/emailer/testing_middleware.rb",
     "lib/emailer/tofile_smtp_facade.rb",
     "spec/emailer/authsmtp_facade_spec.rb",
     "spec/emailer/logger_smtp_facade_spec.rb",
     "spec/emailer/mail_queue_spec.rb",
     "spec/emailer/mock_smtp_facade_spec.rb",
     "spec/emailer/smtp_facade_spec.rb",
     "spec/emailer/testing_middlerware_spec.rb",
     "spec/emailer/tofile_smtp_facade_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/erikhansson/emailer}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A really simple way to send emails...}
  s.test_files = [
    "spec/emailer/authsmtp_facade_spec.rb",
     "spec/emailer/logger_smtp_facade_spec.rb",
     "spec/emailer/mail_queue_spec.rb",
     "spec/emailer/mock_smtp_facade_spec.rb",
     "spec/emailer/smtp_facade_spec.rb",
     "spec/emailer/testing_middlerware_spec.rb",
     "spec/emailer/tofile_smtp_facade_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.4"])
      s.add_runtime_dependency(%q<bjornblomqvist-tmail>, [">= 0.0.2"])
      s.add_runtime_dependency(%q<uuid>, [">= 2.0.2"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.4"])
      s.add_dependency(%q<bjornblomqvist-tmail>, [">= 0.0.2"])
      s.add_dependency(%q<uuid>, [">= 2.0.2"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.4"])
    s.add_dependency(%q<bjornblomqvist-tmail>, [">= 0.0.2"])
    s.add_dependency(%q<uuid>, [">= 2.0.2"])
  end
end
