# frozen_string_literal: true

require "spec_helper"
require "devloop/diff_parser"

describe Devloop::DiffParser do
  let(:diff1) do
    <<~DIFF
      diff --git a/spec/models/team_spec.rb b/spec/models/team_spec.rb
      index 19772f2a..a32824f9 100644
      --- a/spec/models/team_spec.rb
      +++ b/spec/models/team_spec.rb
      @@ -10,2 +10,2 @@ describe Team do
      -  it "has a valid factory" do
      -    expect(team).to be_valid
      +  it "has valid factory" do
      +    expect(team).not_to be_valid
      diff --git a/spec/models/user_spec.rb b/spec/models/user_spec.rb
      index 410ffa8c..610d9e19 100644
      --- a/spec/models/user_spec.rb
      +++ b/spec/models/user_spec.rb
      @@ -167 +167 @@ describe User do
      -          web_auth_token_generated_at: 50.minutes.ago,
      +          web_auth_token_generated_at: 10.minutes.ago,
    DIFF
  end

  let(:diff2) do
    <<~DIFF
          diff --git a/spec/models/team_spec.rb b/spec/models/team_spec.rb
      index 19772f2a..9f614e20 100644
      --- a/spec/models/team_spec.rb
      +++ b/spec/models/team_spec.rb
      @@ -19 +19 @@ describe Team do
      -    it "has_many emojis" do
      +    it "has_many eojis" do
      @@ -24,2 +24,2 @@ describe Team do
      -  describe "normalize attributes" do
      -    it "does not allow empty string values" do
      +  describe "normalize attrbtes" do
      +    it "does not allw empty sting values" do
    DIFF
  end

  it "parses the diff correctly" do
    expect(Devloop::DiffParser.call(diff1)).to eq(["spec/models/team_spec.rb:10", "spec/models/user_spec.rb:167"])
    expect(Devloop::DiffParser.call(diff2)).to eq(["spec/models/team_spec.rb:19", "spec/models/team_spec.rb:24"])
  end
end
