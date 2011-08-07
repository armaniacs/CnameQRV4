class Host < AWS::Record::Base
  include CheckHelper

  string_attr :ip
  string_attr :hostname
  string_attr :type
  integer_attr :preference
  datetime_attr :time
  integer_attr :alive
  string_attr :country
  string_attr :continent
  integer_attr :checkpref, :default_value => 0
  string_attr :tracefile
  datetime_attr :lastmodifiedtime
  integer_attr :nouse
  string_attr :failreason
  string_attr :targetnet
  integer_attr :targetasnum

  scope :running, where(:alive => 1)
  scope :running_by_time, order(:time)


  def uptodate
    ch_tf, ch_body, ch_lm = check_host self.ip
    if ch_tf
      self.alive = 1
      self.checkpref = 0
      self.lastmodifiedtime = ch_lm
    end
    self.time = Time.now
    self.save
  end



  def period_check # sqs
    if self.checkpref < 150 and (Time.now - self.time > 500)
      check_host_sqs self.ip
    end
  end

  def period_check_direct # direct
    if self.checkpref < 150 and (Time.now - self.time > 500)

      ch_tf, ch_body, ch_lm = check_host self.ip
      if ch_tf && ch_lm
        self.lastmodifiedtime = ch_lm
        if Time.now - self.lastmodifiedtime > 86400 * 2 # DELAY
          self.checkpref += 1
          self.failreason = "DELAY"
        else
          self.alive = 1
          self.checkpref = 0
          self.failreason = ""
        end
      else
        self.alive = 0
        self.checkpref += 1
        self.failreason = ch_lm
      end
      self.time = Time.now
      self.save
    end
  end

end
