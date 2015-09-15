clearing :on
notification :gntp, host: '127.0.0.1'

group :red_green_refactor, halt_on_fail: true do
  rspec_opts = {
    cmd: 'bundle exec rspec',
    results_file: 'tmp/guard_rspec_results.txt',
    all_after_pass: true,
    failed_mode: :focus
  }

  guard :rspec, rspec_opts do
    require 'guard/rspec/dsl'
    dsl = Guard::RSpec::Dsl.new(self)

    # Feel free to open issues for suggestions and improvements

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)
  end

  rubocop_opts = {
    all_on_start: true,
    cli: [
      '--format',
      'progress',
      '--format',
      'html',
      '-o',
      'rubocop.html'
    ],
    notification: true
  }

  guard :rubocop, rubocop_opts do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end

#  vim: set ts=8 sw=2 tw=0 ft=ruby et :
