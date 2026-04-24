defmodule PureAdmin.HelpersTest do
  use ExUnit.Case, async: true

  doctest PureAdmin.Helpers

  alias PureAdmin.Helpers

  describe "safe_url/2" do
    test "custom scheme deep links pass through" do
      assert Helpers.safe_url("slack://channel?team=T1") == "slack://channel?team=T1"
      assert Helpers.safe_url("intent://scan/#Intent;end") == "intent://scan/#Intent;end"
      assert Helpers.safe_url("myapp://open") == "myapp://open"
      assert Helpers.safe_url("ftp://host/file") == "ftp://host/file"
    end

    test "sms and geo are allowed" do
      assert Helpers.safe_url("sms:+420123") == "sms:+420123"
      assert Helpers.safe_url("geo:50.08,14.42") == "geo:50.08,14.42"
    end

    test "rejects dangerous schemes regardless of case/whitespace" do
      assert Helpers.safe_url("JavaScript:alert(1)") == "#"
      assert Helpers.safe_url("  javascript:alert(1)") == "#"
      assert Helpers.safe_url("\tjavascript:alert(1)") == "#"
      assert Helpers.safe_url("VBSCRIPT:foo") == "#"
      assert Helpers.safe_url("File:///etc/passwd") == "#"
    end

    test "non-string input returns fallback" do
      assert Helpers.safe_url(nil) == "#"
      assert Helpers.safe_url(123) == "#"
      assert Helpers.safe_url(:atom) == "#"
    end

    test "empty / whitespace input returns fallback" do
      assert Helpers.safe_url("") == "#"
      assert Helpers.safe_url("   ") == "#"
    end

    test "custom fallback" do
      assert Helpers.safe_url("javascript:nope", "/home") == "/home"
      assert Helpers.safe_url(nil, "/home") == "/home"
    end
  end
end
