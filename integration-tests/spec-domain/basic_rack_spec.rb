require 'spec_helper_domain'

shared_examples_for "basic rack" do

  before(:each) do
    visit context
    page.should have_content('it worked')
  end

  it "should work" do
    page.find("#success")[:class].strip.should == 'basic-rack'
  end

  it "should be running under the proper ruby version" do
    page.find("#ruby-version").text.strip.should == RUBY_VERSION
  end

  it "should not have a vfs path for __FILE__" do
    page.find("#path").text.strip.should_not match(/^vfs:/)
  end

end

describe "basic rack test with heredoc" do

  deploy <<-END.gsub(/^ {4}/,'')

    application:
      root: #{File.dirname(__FILE__)}/../apps/rack/basic
      env: development
    web:
      context: /basic-rack-with-heredoc
    ruby:
      version: #{RUBY_VERSION[0,3]}

  END

  let(:context) { '/basic-rack-with-heredoc' }
  it_should_behave_like "basic rack"

end

describe "basic rack test with hash" do

  deploy( :application => { :root => "#{File.dirname(__FILE__)}/../apps/rack/basic", :env => 'development' },
          :web => { :context => '/basic-rack-with-hash' },
          :ruby => { :version => RUBY_VERSION[0,3] } )  


  let(:context) { '/basic-rack-with-hash' }
  it_should_behave_like "basic rack"

end