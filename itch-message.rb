#!/usr/bin/env ruby

require 'bindata'

class Itch
  def initialize(filename)
    @filename = filename
  end

  def each_record
    File.open(@filename) do |io|
      file = ItchFile2.read(io)
      file.records.each do |rec|
        yield rec.data
      end
    end
  end

  class SysEventMsg < BinData::Record
    endian :big

    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    string :event_code, :read_length => 1
  end

  class StockDirMsg < BinData::Record
    endian :big

    uint16 :stock_locate
    uint16 :tracking
    uint64 :timestamp
    string :stock, :read_length => 8
    string :mkt_cat, :read_length => 1
    string :fin_status, :read_length => 1
    uint32 :r_lot_size
    string :r_lot_only, :read_length => 1
    string :issue_class, :read_length => 1
    string :issue_subtype, :read_length => 2
    string :authenticity, :read_length => 1
    string :ss_thresh_ind, :read_length => 1
    string :ipo_flag, :read_length => 1
    string :luld_ref_price_tier, :read_length => 1
    string :etp_flag, :read_length => 1
    uint32 :etp_leverage_factor
    string :inverse_indicator, :read_length => 1
  end

  class StockTradingActionMsg < BinData::Record
    endian :big

    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    string :stock, :read_length => 8
    string :trading_state, :read_length => 1
    string :reserved, :read_length => 1
    string :reason, :read_length => 4
  end

  class RegShoMsg < BinData::Record
    endian :big

    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    string :stock, :read_length => 8
    string :reg_sho_action, :read_length => 1
  end

  class MktPartPosMsg < BinData::Record
    endian :big
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    string :mpid, :read_length => 4
    string :stock, :read_length => 8
    string :primary_mkt_maker, :read_length => 1
    string :mkt_maker_mode, :read_length => 1
    string :mkt_participant_status, :read_length => 1
  end

  class MwcbDeclineMSg < BinData::Record
    endian :big

    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    uint64 :level1
    uint64 :level2
    uint64 :level3
  end

  class MwcbBreachMsg < BinData::Record
    endian :big
  
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    string :breached_level, :read_length => 1
  end

  class IpoQuotingMsg < BinData::Record
    endian :big

    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    string :stock, :read_length => 8
    uint32 :ipo_quotation_release_time
    string :ipo_quotation_release_qualifier, :read_length => 1
    uint32 :ipo_price
  end

  class AddOrderMsg < BinData::Record
    endian :big
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    uint64 :order_ref_number
    string :buysell_indicator, :read_length => 1
    uint32 :shares
    string :stock, :read_length => 8
    uint32 :price
  end

  class AddOrderMpidMsg < BinData::Record
    endian :big
  
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    uint64 :order_ref_number
    uint32 :shares
    string :stock, :read_length => 8
    uint32 :price
    string :attribution, :read_length => 4
  end

class OrdExecMsg < BinData::Record
    endian :big
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    uint64 :order_ref_number

end

class OrdExecPricMsg < BinData::Record
    endian :big
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    uint64 :order_ref_number

end

class OrdCxlMsg < BinData::Record
    endian :big
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    uint64 :order_ref_number

end

class OrdDelMsg < BinData::Record
    endian :big

    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    uint64 :order_ref_number
end

class OrdRplMsg < BinData::Record
    endian :big
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    uint64 :order_ref_number

end

class TrdMsg < BinData::Record
    endian :big
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp

end

class CrossTrdMsg < BinData::Record
    endian :big
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp

end

class BrknTrdMsg < BinData::Record
    endian :big
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp

end

class NoiiMsg < BinData::Record
    endian :big
    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp

end

class RpiiMsg < BinData::Record
    endian :big

    uint16 :stock_locate
    uint16 :tracking_number
    uint64 :timestamp
    string :stock, :read_length => 8
    string :interest_flag, :read_length => 1
end

  class ItchMessage < BinData::Record
    endian :big

    string  :msg_type, :read_length => 1
    choice :data, selection: :msg_type do
        array 'S', type: :SysEventMsg, read_until: :eof
        array 'R', type: :StockDirMsg, read_until: :eof
        array 'H', type: :StockTradingActionMsg, read_until: :eof
        array 'Y', type: :RegShoMsg, read_until: :eof
        array 'L', type: :MktPartPosMsg, read_until: :eof
        array 'V', type: :MwcbDeclineMSg, read_until: :eof
        array 'W', type: :MwcbBreachMsg, read_until: :eof
        array 'K', type: :IpoQuotingMsg, read_until: :eof
        array 'A', type: :AddOrderMsg, read_until: :eof
        array 'F', type: :AddOrderMpidMsg, read_until: :eof
        array 'E', type: :OrdExecMsg, read_until: :eof
        array 'C', type: :OrdExecPricMsg, read_until: :eof
        array 'X', type: :OrdCxlMsg, read_until: :eof
        array 'D', type: :OrdDelMsg, read_until: :eof
        array 'U', type: :OrdRplMsg, read_until: :eof
        array 'P', type: :TrdMsg, read_until: :eof
        array 'Q', type: :CrossTrdMsg, read_until: :eof
        array 'B', type: :BrknTrdMsg, read_until: :eof
        array 'I', type: :NoiiMsg, read_until: :eof
        array 'N', type: :RpiiMsg, read_until: :eof
      end
  end
end

#unless File.exist?('itch50_20150912')
 # puts "No dump file found. Create one with: sudo tcpdump -i eth0 -s 0 -n -w itch50_20150912"
 # exit 1
#end

#cap = Itch.new('itch50_20150912')
#cap.each_record do |str|
#  pp Ether.read(str)
#end
