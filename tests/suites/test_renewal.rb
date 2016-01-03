require "minitest/autorun"
require_relative "../test_helper"

class TestRenewal < Minitest::Test
  def test_auto_discovery
    `cd ./compositions/minimal-setup/ && docker-compose build && docker-compose up -d`

    read_https_content
    output = `docker exec minimalsetup_nginx-acme_1 bash -c 'test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )'`

    assert output.include?("No need to renew certs for #{TEST_DOMAIN}")
  end

  def teardown
    `cd ./compositions/minimal-setup/ && docker-compose stop`
  end
end
