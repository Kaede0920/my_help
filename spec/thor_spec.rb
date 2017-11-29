# -*- coding: utf-8 -*-
require "./spec_helper.rb"

RSpec.describe 'my_help command', type: :aruba do
  context 'version option' do
    before(:each) { run('my_help version') }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output("0.4.5") }
  end

  context 'help option' do
    expected = <<EXPECTED
Commands:
  my_help clean, --clean                  # clean up exe dir.
  my_help delete NAME, --delete NAME      # delete NAME help
  my_help edit NAME, --edit NAME          # edit NAME help(eg test_help)
  my_help help [COMMAND]                  # Describe available commands or on...
  my_help init NAME, --init NAME          # initialize NAME help(eg test_help).
  my_help install_local, --install_local  # install local after edit helps
  my_help list, --list                    # list specific helps
  my_help make, --make                    # make executables for all helps.
  my_help version, -v                     # show program version
EXPECTED
    before(:each) { run('my_help help') }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected) }
  end

  context 'init option' do
    before(:each) { run('my_help init') }

    expected=<<EXPECTED
ERROR: "my_help init" was called with no arguments
Usage: "my_help init NAME, --init NAME"
EXPECTED
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected.chomp) }
  end


  context 'edit option' do
    expected = <<EXPECTED
ERROR: "my_help edit" was called with no arguments
Usage: "my_help edit NAME, --edit NAME"
EXPECTED
  before(:each) { run('my_help edit') }
  it { expect(last_command_started).to be_successfully_executed }
  it { expect(last_command_started).to have_output(expected.chomp) }
  end

=begin
  context 'init option2' do
    expected = <<EXPECTED
ERROR: "my_help init" was called with no arguments
Usage: "my_help init NAME, --init NAME"
EXPECTED
  before(:each) { run('my_help init') }
  it { expect(last_command_started).to be_successfully_executed }
  it { expect(last_command_started).to have_output(expected.chomp) }
  end
=end

=begin
  context 'make option' do
    expected = <<EXPECTED
"exe/my_todo"
#<Errno::ENOENT: No such file or directory @ rb_sysopen - exe/my_todo>
EXPECTED
    before(:each) { run('my_help make') }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected.chomp) }
  end
=end
  context 'list option' do
    expected = "Specific help file:\n  my_todo.yml\t:my todo\n  emacs_help.yml\t:emacsのキーバインド\n  yagi_help2\t:yagiのサンプル\n  test_help.yml\t:ヘルプのサンプル雛形\n"

    before(:each) { run('my_help list') }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected.chomp) }
  end
end
