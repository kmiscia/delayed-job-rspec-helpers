RSpec::Matchers.define :queue_delayed_job do |handler, expected_delayed_job_count|

  match do |proc|
    previous_delayed_jobs_count = Delayed::Job.where("delayed_jobs.handler like '%#{handler}%'").length
    proc.call
    expected_delayed_job_count ||= 1

    new_delayed_jobs = Delayed::Job.where("delayed_jobs.handler like '%#{handler}%'")
    (previous_delayed_jobs_count + expected_delayed_job_count == new_delayed_jobs.length) && (new_delayed_jobs.all?{| job| job.handler.include?(handler) })
  end

  def supports_block_expectations?
    true
  end

  failure_message do |actual|
    "expected block to queue '#{handler}'"
  end

  failure_message_when_negated do |actual|
    "expected block to not queue '#{handler}'"
  end
end