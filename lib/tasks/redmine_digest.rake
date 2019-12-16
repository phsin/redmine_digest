namespace :redmine_digest do

  desc 'Create digest_rule for all users'
  task create_digest: [:environment] do
    puts "#{Time.now} Create digest for all users"
    count=0
    User.find_each do |user|
      #puts user.inspect
      puts "rule #{count}"
      t = user.digest_rules.create(
          name:             'default_digest',
          notify:           DigestRule::DIGEST_ONLY,
          recurrent:        DigestRule::DAILY,
          project_selector: DigestRule::ALL
       #   event_ids: %w(issue_created project_changed subject_changed assignee_changed status_changed percent_changed version_changed other_attr_changed attachment_added description_changed comment_added),
      )
       puts t.inspect
      count=count+1
    end
    puts "Created #{count} digest rules"
  end

  desc 'Populate digest_rule for active users'
  task populate: [:environment] do
    puts "#{Time.now} Create digest rule for active users"
    count=0
    #User.where( :status => 1).find_each do |user|
    User.where( "status = 1").find_each do |user|
      if user.digest_rules.count==0
        t = user.digest_rules.create(
            name:             'default_digest',
            notify:           DigestRule::DIGEST_ONLY,
            recurrent:        DigestRule::DAILY,
            project_selector: DigestRule::ALL
        #   event_ids: %w(issue_created project_changed subject_changed assignee_changed status_changed percent_changed version_changed other_attr_changed attachment_added description_changed comment_added),
        )
        puts t.inspect
        count=count+1
      end
    end
    puts "Created #{count} digest rules"
  end

  desc 'Send daily digests by all active rules'
  task send_daily: [:environment] do
    puts "#{Time.now} Send daily digests."
    send_digests DigestRule.active.daily
  end

  desc 'Send weekly digests by all active rules'
  task send_weekly: [:environment] do
    puts "#{Time.now} Send weekly digests."
    send_digests DigestRule.active.weekly
  end

  desc 'Send monthly digests by all active rules'
  task send_monthly: [:environment] do
    puts "#{Time.now} Send monthly digests."
    send_digests DigestRule.active.monthly
  end

  def send_digests(rules)
    rules_count = rules.count
    puts "#{Time.now} Found #{rules_count} rules."
    rules.each_with_index do |rule, idx|
      send_digest_by_rule(rule, "#{idx + 1} / #{rules_count}")
    end
  end

  def send_digest_by_rule(rule, npp)
    puts "#{Time.now} #{npp} Sending #{rule.recurrent} digest [#{rule.id}] to #{rule.user.mail} <#{rule.user.login}>"

    digest = RedmineDigest::Digest.new(rule)
    if digest.issues.any?
      DigestMailer.with_synched_deliveries do
        DigestMailer.digest_email(digest).deliver
      end
      puts "#{Time.now} Done. Digest contains #{digest.issues.count} issues."
    else
      puts "#{Time.now} Done. Digest empty and was not sent."
    end

  rescue StandardError => e
    $stderr.puts "#{Time.now} Failed to send digest with error: #{e.class.name}\n#{e.message}"
    if Rails.env == 'development'
      $stderr.puts e.backtrace.join("\n")
    end
  end

end
