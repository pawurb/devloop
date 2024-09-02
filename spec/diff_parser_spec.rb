# frozen_string_literal: true

require "spec_helper"
require "devloop/diff_parser"

describe Devloop::DiffParser do
  context "first line of a file was edited" do
    let(:diff) do
      <<~DIFF
            diff --git a/spec/models/team_spec.rb b/spec/models/team_spec.rb
        index 19772f2a..9f614e20 100644
        --- a/spec/models/team_spec.rb
        +++ b/spec/models/team_spec.rb
        @@ -1 +1,3 @@ describe Team do
        -    it "has_many emojis" do
        +    it "has_many eojis" do
        @@ -24,2 +24,2 @@ describe Team do
        -  describe "normalize attributes" do
        -    it "does not allow empty string values" do
        +  describe "normalize attrbtes" do
        +    it "does not allw empty string values" do
      DIFF
    end

    it "will run the whole file" do
      expect(Devloop::DiffParser.call(diff)).to eq(["spec/models/team_spec.rb"])
    end
  end

  context "the project root is the same as git root" do
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
        +    it "does not allw empty string values" do
      DIFF
    end

    it "parses the diff correctly" do
      expect(Devloop::DiffParser.call(diff1)).to eq(["spec/models/team_spec.rb:10", "spec/models/user_spec.rb:167"])
      expect(Devloop::DiffParser.call(diff2)).to eq(["spec/models/team_spec.rb:19:20:21:22:23:24"])
    end
  end

  context "the project root is different from the git root" do
    let(:diff) do
      <<~DIFF
        diff --git a/src/spec/models/team_spec.rb b/src/spec/models/team_spec.rb
        index 19772f2a..9f614e20 100644
        --- a/src/spec/models/team_spec.rb
        +++ b/src/spec/models/team_spec.rb
        @@ -19 +19 @@ describe Team do
        -    it "has_many emojis" do
        +    it "has_many eojis" do
        @@ -24,2 +24,2 @@ describe Team do
        -  describe "normalize attributes" do
        -    it "does not allow empty string values" do
        +  describe "normalize attrbtes" do
        +    it "does not allw empty string values" do
      DIFF
    end

    it "parses the diff correctly" do
      allow_any_instance_of(Devloop::DiffParser).to receive(:git_root_path).and_return("/Users/username/projects/")
      allow_any_instance_of(Devloop::DiffParser).to receive(:project_path).and_return("src/")
      expect(Devloop::DiffParser.call(diff)).to eq(["spec/models/team_spec.rb:19:20:21:22:23:24"])
    end
  end

  context "removes 0 line numbers" do
    let(:diff) do
      <<~DIFF
        diff --git a/spec/config_spec.rb b/spec/config_spec.rb
        index d9716e7..b470ec2 100644
        --- a/spec/config_spec.rb
        +++ b/spec/config_spec.rb
        @@ -5 +5 @@ require "spec_helper"
        -describe "PgLocksMonitor::Confiuration" do
        +describe "PgLocksMonitor::Configuration" do
        @@ -8,2 +8,5 @@ describe "PgLocksMonitor::Confiuration" do
        -    expect(config.notify_locks).to eq true
        -    expect(config.notify_blocking).to eq true
        +    expect(config.monitor_locks).to eq true
        +    expect(config.monitor_blocking).to eq true
        +    expect(config.locks_min_duration_ms).to eq 200
        +    expect(config.blocking_min_duration_ms).to eq 100
        +    expect(config.notifier_class).to eq PgLocksMonitor::DefaultNotifier
        @@ -14 +17 @@ describe "PgLocksMonitor::Confiuration" do
        -      config.notify_locks = false
        +      config.monitor_locks = false
        @@ -17 +20 @@ describe "PgLocksMonitor::Confiuration" do
        -    expect(PgLocksMonitor.configuration.notify_locks).to eq false
        +    expect(PgLocksMonitor.configuration.monitor_locks).to eq false
        diff --git a/spec/default_notifier_spec.rb b/spec/default_notifier_spec.rb
        new file mode 100644
        index 0000000..d99d3a1
        --- /dev/null
        +++ b/spec/default_notifier_spec.rb
        @@ -0,0 +1,11 @@
        +# frozen_string_literal: true
        +
        +require "spec_helper"
        +
        +describe PgLocksMonitor::DefaultNotifier do
        +  it "requires correct config if Slack notifications enabled" do
        +    expect {
        +      PgLocksMonitor::DefaultNotifier.call({})
        +    }.not_to raise_error
        +  end
        +end
      DIFF
    end

    it "parses the diff correctly" do
      expect(Devloop::DiffParser.call(diff)).to eq(["spec/config_spec.rb:5:6:7:8:9:10:11:12:13:14:15:16:17", "spec/default_notifier_spec.rb"])
    end
  end

  context "executes each matching spec" do
    let(:diff) do
      <<~DIFF
        diff --git a/spec/models/user_spec.rb b/spec/models/user_spec.rb
        index 410ffa8c..0266ea38 100644
        --- a/spec/models/user_spec.rb
        +++ b/spec/models/user_spec.rb
        @@ -10,3 +10,3 @@ describe User do
        -  it "has a valid factory" do
        -    expect(user).to be_valid
        -  end
        +  it "has a valid factory" do #
        +    expect(user).to be_valid #
        +  end #
        @@ -14,2 +14,2 @@ describe User do
        -  it "has pending_feedbacks" do
        -    expect(create(:user).pending_feedbacks).to eq []
        +  it "has pending_feedbacks" do#
        +    expect(create(:user).pending_feedbacks).to eq [] #
        @@ -17 +17 @@ describe User do
        -
        +#
      DIFF
    end

    it "parses the diff correctly" do
      expect(Devloop::DiffParser.call(diff)).to eq(["spec/models/user_spec.rb:10:11:12:13:14:15:16:17"])
    end
  end
end
