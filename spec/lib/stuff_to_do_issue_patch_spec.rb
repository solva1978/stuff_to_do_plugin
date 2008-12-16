require File.dirname(__FILE__) + '/../spec_helper'

describe Issue, 'after_save' do
  it 'should include update_next_issues' do
    callbacks = Issue.after_save
    callbacks.should_not be_nil
    
    callbacks.should satisfy do |callbacks|
      found = false
      callbacks.each do |callback|
        found = true if callback.method == :update_next_issues
      end
      found
    end
  end
end

describe Issue, 'update_next_issues' do
  it 'should call NextIssue#closing_issue if the issue is closed' do
    issue = Issue.new
    issue.should_receive(:closed?).and_return(true)
    NextIssue.should_receive(:closing_issue).with(issue)
    issue.update_next_issues
  end

  it 'should not call NextIssue#closing_issue if the issue is open' do
    issue = Issue.new
    issue.should_receive(:closed?).and_return(false)
    NextIssue.should_not_receive(:closing_issue)
    issue.update_next_issues
  end

  it 'should return true for the callbacks' do
    NextIssue.stub!(:closing_issue)

    issue = Issue.new
    issue.stub!(:closed?).and_return(false)
    issue.update_next_issues.should be_true
  end
end
