require 'fastimage'

require_relative 'module'
require 'spaceship/connect_api/models/app_screenshot_set'

module Deliver
  # AppScreenshot represents one screenshots for one specific locale and
  # device type.
  class AppScreenshot # rubocop:disable Metrics/ClassLength
    #
    module ScreenSize
      # iPhone 4s
      IOS_35 = "iOS-3.5-in"
      # iPhone SE (1st gen)
      IOS_40 = "iOS-4-in"
      # iPhone SE (3rd generation), iPhone 8
      IOS_47 = "iOS-4.7-in"
      # iPhone 8 Plus
      IOS_55 = "iOS-5.5-in"
      # iPhone 11 Pro, iPhone XS, iPhone X
      IOS_58 = "iOS-5.8-in"
      # iPhone 16, iPhone 15, iPhone 14, iPhone 13, iPhone 12, iPhone 11, iPhone XR
      IOS_61 = "iOS-6.1-in"
      # iPhone 11 Pro Max, iPhone XS Max
      IOS_65 = "iOS-6.5-in"
      # iPhone 16 Plus, iPhone 15 Pro Max, iPhone 15 Plus, iPhone 14 Pro Max, iPhone 14 Plus, iPhone 13 Pro Max, iPhone 12 Pro Max
      IOS_67 = "iOS-6.7-in"

      # iPad (9th gen)
      IOS_IPAD = "iOS-iPad"
      # iPad Pro (10.5-inch)
      IOS_IPAD_10_5 = "iOS-iPad-10.5"
      # iPad Pro (11-inch), iPad Air (11-inch), iPad (10th gen)
      IOS_IPAD_11 = "iOS-iPad-11"
      # iPad Pro (12.9-inch) (2nd gen)
      IOS_IPAD_PRO = "iOS-iPad-Pro"
      # iPad Pro (12.9-inch) (6th gen)
      IOS_IPAD_PRO_12_9 = "iOS-iPad-Pro-12.9"
      # Legacy - iPad Pro (13-inch) (deprecated)
      IOS_IPAD_13 = "iOS-iPad-13"

      # iPhone SE (1st gen) iMessage
      IOS_40_MESSAGES = "iOS-4-in-messages"
      # iPhone SE (3rd generation), iPhone 8 iMessage
      IOS_47_MESSAGES = "iOS-4.7-in-messages"
      # iPhone 8 Plus iMessage
      IOS_55_MESSAGES = "iOS-5.5-in-messages"
      # iPhone 16, iPhone 15, iPhone 14, iPhone 13, iPhone X, iPhone XS, iPhone 13 mini iMessage
      IOS_61_MESSAGES = "iOS-6.1-in-messages"
      # iPhone 11 Pro, iPhone XS, iPhone X iMessage
      IOS_58_MESSAGES = "iOS-5.8-in-messages"
      # iPhone 16, iPhone 15, iPhone 14, iPhone 13, iPhone 12, iPhone 11, iPhone XR iMessage
      IOS_61_MESSAGES = "iOS-6.1-in-messages"
      # iPhone 11 Pro Max, iPhone XS Max iMessage
      IOS_65_MESSAGES = "iOS-6.5-in-messages"
      # iPhone 16 Plus, iPhone 15 Pro Max, iPhone 15 Plus, iPhone 14 Pro Max, iPhone 14 Plus, iPhone 13 Pro Max, iPhone 12 Pro Max iMessage
      IOS_67_MESSAGES = "iOS-6.7-in-messages"

      # iPad (9th gen) iMessage
      IOS_IPAD_MESSAGES = "iOS-iPad-messages"
      # iPad Pro (10.5-inch) iMessage
      IOS_IPAD_10_5_MESSAGES = "iOS-iPad-10.5-messages"
      # iPad Pro (11-inch), iPad Air (11-inch), iPad (10th gen) iMessage
      IOS_IPAD_11_MESSAGES = "iOS-iPad-11-messages"
      # iPad Pro (12.9-inch) (2nd gen) iMessage
      IOS_IPAD_PRO_MESSAGES = "iOS-iPad-Pro-messages"
      # iPad Pro (12.9-inch) (6th gen) iMessage
      IOS_IPAD_PRO_12_9_MESSAGES = "iOS-iPad-Pro-12.9-messages"
      # Legacy - iPad Pro (13-inch) (deprecated) iMessage
      IOS_IPAD_13_MESSAGES = "iOS-iPad-13-messages"

      # Apple Watch Series 3 (42mm)
      IOS_APPLE_WATCH_SERIES_3 = "iOS-Apple-Watch-Series3"
      # Apple Watch Series 4
      IOS_APPLE_WATCH_SERIES_4 = "iOS-Apple-Watch-Series4"
      # Apple Watch Series 7
      IOS_APPLE_WATCH_SERIES_7 = "iOS-Apple-Watch-Series7"
      # Apple Watch Series 10
      IOS_APPLE_WATCH_SERIES_10 = "iOS-Apple-Watch-Series10"
      # Apple Watch Ultra
      IOS_APPLE_WATCH_ULTRA = "iOS-Apple-Watch-Ultra"
      # Legacy alias for Series 3
      IOS_APPLE_WATCH = IOS_APPLE_WATCH_SERIES_3

      # Apple TV
      APPLE_TV = "Apple-TV"

      # Mac
      MAC = "Mac"

      # Apple Vision Pro
      APPLE_VISION_PRO = "Apple-Vision-Pro"
    end

    # @return [Deliver::ScreenSize] the screen size (device type)
    #  specified at {Deliver::ScreenSize}
    attr_accessor :screen_size

    attr_accessor :path

    attr_accessor :language

    # @param path (String) path to the screenshot file
    # @param language (String) Language of this screenshot (e.g. English)
    # @param screen_size (Deliver::AppScreenshot::ScreenSize) the screen size, which
    #  will automatically be calculated when you don't set it. (Deprecated)
    def initialize(path, language, screen_size = nil)
      UI.deprecated('`screen_size` for Deliver::AppScreenshot.new is deprecated in favor of the default behavior to calculate size automatically. Passed value is no longer validated.') if screen_size
      self.path = path
      self.language = language
      self.screen_size = screen_size || self.class.calculate_screen_size(path)
    end

    # The iTC API requires a different notation for the device
    def device_type
      matching = {
        ScreenSize::IOS_35 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_35,
        ScreenSize::IOS_40 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_40,
        ScreenSize::IOS_47 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_47,
        ScreenSize::IOS_55 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_55,
        ScreenSize::IOS_58 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_58,
        ScreenSize::IOS_61 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_61,
        ScreenSize::IOS_65 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_65,
        ScreenSize::IOS_67 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_67,
        ScreenSize::IOS_IPAD => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPAD_97,
        ScreenSize::IOS_IPAD_10_5 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPAD_105,
        ScreenSize::IOS_IPAD_11 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPAD_PRO_3GEN_11,
        ScreenSize::IOS_IPAD_PRO => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPAD_PRO_129,
        ScreenSize::IOS_IPAD_PRO_12_9 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPAD_PRO_3GEN_129,
        ScreenSize::IOS_40_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_40,
        ScreenSize::IOS_47_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_47,
        ScreenSize::IOS_55_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_55,
        ScreenSize::IOS_58_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_58,
        ScreenSize::IOS_61_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_61,
        ScreenSize::IOS_65_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_65,
        ScreenSize::IOS_67_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_67,
        ScreenSize::IOS_IPAD_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPAD_97,
        ScreenSize::IOS_IPAD_PRO_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPAD_PRO_129,
        ScreenSize::IOS_IPAD_PRO_12_9_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPAD_PRO_3GEN_129,
        ScreenSize::IOS_IPAD_10_5_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPAD_105,
        ScreenSize::IOS_IPAD_11_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPAD_PRO_3GEN_11,
        ScreenSize::MAC => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_DESKTOP,
        ScreenSize::IOS_APPLE_WATCH_SERIES_3 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_SERIES_3,
        ScreenSize::IOS_APPLE_WATCH_SERIES_4 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_SERIES_4,
        ScreenSize::IOS_APPLE_WATCH_SERIES_7 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_SERIES_7,
        ScreenSize::IOS_APPLE_WATCH_SERIES_10 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_SERIES_10,
        ScreenSize::IOS_APPLE_WATCH_ULTRA => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_ULTRA,
        # Legacy mappings
        ScreenSize::IOS_APPLE_WATCH => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_SERIES_3,
        ScreenSize::APPLE_TV => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_APPLE_TV,
        ScreenSize::APPLE_VISION_PRO => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_APPLE_VISION_PRO
      }
      return matching[self.screen_size]
    end

    # Nice name
    def formatted_name
      matching = {
        ScreenSize::IOS_35 => "iPhone 4s",
        ScreenSize::IOS_40 => "iPhone SE (1st gen)",
        ScreenSize::IOS_47 => "iPhone SE (3rd gen)",
        ScreenSize::IOS_55 => "iPhone 8 Plus",
        ScreenSize::IOS_58 => "iPhone 11 Pro",
        ScreenSize::IOS_61 => "iPhone 16",
        ScreenSize::IOS_65 => "iPhone 11 Pro Max",
        ScreenSize::IOS_67 => "iPhone 15 Pro Max",
        ScreenSize::IOS_IPAD => "iPad (9th gen)",
        ScreenSize::IOS_IPAD_10_5 => "iPad Pro (10.5-inch)",
        ScreenSize::IOS_IPAD_11 => "iPad Pro (11-inch) (M4)",
        ScreenSize::IOS_IPAD_PRO => "iPad Pro (12.9-inch) (2nd gen)",
        ScreenSize::IOS_IPAD_PRO_12_9 => "iPad Pro (12.9-inch) (6th gen)",
        ScreenSize::IOS_40_MESSAGES => "iPhone SE (1st gen) (iMessage)",
        ScreenSize::IOS_47_MESSAGES => "iPhone SE (3rd gen) (iMessage)",
        ScreenSize::IOS_55_MESSAGES => "iPhone 8 Plus (iMessage)",
        ScreenSize::IOS_58_MESSAGES => "iPhone 11 Pro (iMessage)",
        ScreenSize::IOS_61_MESSAGES => "iPhone 16 (iMessage)",
        ScreenSize::IOS_65_MESSAGES => "iPhone 11 Pro Max (iMessage)",
        ScreenSize::IOS_67_MESSAGES => "iPhone 15 Pro Max (iMessage)",
        ScreenSize::IOS_IPAD_MESSAGES => "iPad (9th gen) (iMessage)",
        ScreenSize::IOS_IPAD_PRO_MESSAGES => "iPad Pro (12.9-inch) (2nd gen) (iMessage)",
        ScreenSize::IOS_IPAD_PRO_12_9_MESSAGES => "iPad Pro (12.9-inch) (6th gen) (iMessage)",
        ScreenSize::IOS_IPAD_10_5_MESSAGES => "iPad Pro (10.5-inch) (iMessage)",
        ScreenSize::IOS_IPAD_11_MESSAGES => "iPad Pro (11-inch) (M4) (iMessage)",
        ScreenSize::MAC => "Mac",
        ScreenSize::IOS_APPLE_WATCH_SERIES_3 => "Apple Watch Series 3",
        ScreenSize::IOS_APPLE_WATCH_SERIES_4 => "Apple Watch Series 4",
        ScreenSize::IOS_APPLE_WATCH_SERIES_7 => "Apple Watch Series 7",
        ScreenSize::IOS_APPLE_WATCH_SERIES_10 => "Apple Watch Series 10",
        ScreenSize::IOS_APPLE_WATCH_ULTRA => "Apple Watch Ultra",
        # Legacy mappings
        ScreenSize::IOS_APPLE_WATCH => "Apple Watch Series 3",
        ScreenSize::APPLE_TV => "Apple TV 4K",
        ScreenSize::APPLE_VISION_PRO => "Apple Vision Pro"
      }
      return matching[self.screen_size]
    end

    # Validates the given screenshots (size and format)
    def is_valid?
      UI.deprecated('Deliver::AppScreenshot#is_valid? is deprecated in favor of Deliver::AppScreenshotValidator')
      return false unless ["png", "PNG", "jpg", "JPG", "jpeg", "JPEG"].include?(self.path.split(".").last)

      return self.screen_size == self.class.calculate_screen_size(self.path)
    end

    def is_messages?
      return [
        ScreenSize::IOS_40_MESSAGES,
        ScreenSize::IOS_47_MESSAGES,
        ScreenSize::IOS_55_MESSAGES,
        ScreenSize::IOS_58_MESSAGES,
        ScreenSize::IOS_61_MESSAGES,
        ScreenSize::IOS_65_MESSAGES,
        ScreenSize::IOS_67_MESSAGES,
        ScreenSize::IOS_IPAD_MESSAGES,
        ScreenSize::IOS_IPAD_PRO_MESSAGES,
        ScreenSize::IOS_IPAD_PRO_12_9_MESSAGES,
        ScreenSize::IOS_IPAD_10_5_MESSAGES,
        ScreenSize::IOS_IPAD_11_MESSAGES
      ].include?(self.screen_size)
    end

    def self.device_messages
      # This list does not include iPad Pro 12.9-inch (3rd generation)
      # because it has same resolution as IOS_IPAD_PRO and will clobber
      return {
        ScreenSize::IOS_67_MESSAGES => [
          [1290, 2796],
          [2796, 1290],
          [1284, 2778],
          [2778, 1284],
          [1320, 2868],
          [2868, 1320]
        ],
        ScreenSize::IOS_65_MESSAGES => [
          [1242, 2688],
          [2688, 1242],
          [1260, 2736],
          [2736, 1260]
        ],
        ScreenSize::IOS_58_MESSAGES => [
          [1125, 2436],
          [2436, 1125]
        ],
        ScreenSize::IOS_61_MESSAGES => [
          [1080, 2340],
          [2340, 1080],
          [1170, 2532],
          [2532, 1170],
          [1179, 2556],
          [2556, 1179],
          [1206, 2622],
          [2622, 1206]
        ],
        ScreenSize::IOS_55_MESSAGES => [
          [1242, 2208],
          [2208, 1242]
        ],
        ScreenSize::IOS_47_MESSAGES => [
          [750, 1334],
          [1334, 750]
        ],
        ScreenSize::IOS_40_MESSAGES => [
          [640, 1096],
          [640, 1136],
          [1136, 600],
          [1136, 640]
        ],
        ScreenSize::IOS_IPAD_MESSAGES => [
          [1024, 748],
          [1024, 768],
          [2048, 1496],
          [2048, 1536],
          [768, 1004],
          [768, 1024],
          [1536, 2008],
          [1536, 2048]
        ],
        ScreenSize::IOS_IPAD_10_5_MESSAGES => [
          [1668, 2224],
          [2224, 1668]
        ],
        ScreenSize::IOS_IPAD_11_MESSAGES => [
          [1668, 2420],
          [2420, 1668],
          [1668, 2388],
          [2388, 1668],
          [1640, 2360],
          [2360, 1640],
          [1488, 2266],
          [2266, 1488]
        ],
        ScreenSize::IOS_IPAD_PRO_MESSAGES => [
          [2732, 2048],
          [2048, 2732]
        ],
        ScreenSize::IOS_IPAD_PRO_12_9_MESSAGES => [
          [2048, 2732],
          [2732, 2048],
          [2064, 2752],
          [2752, 2064]
        ],
      }
    end

    # reference: https://help.apple.com/app-store-connect/#/devd274dd925
    def self.devices
      # This list does not include iPad Pro 12.9-inch (3rd generation)
      # because it has same resolution as IOS_IPAD_PRO and will clobber
      return {
        ScreenSize::IOS_67 => [
          [1290, 2796],
          [2796, 1290],
          [1284, 2778],
          [2778, 1284],
          [1320, 2868],
          [2868, 1320]
        ],
        ScreenSize::IOS_65 => [
          [1242, 2688],
          [2688, 1242],
          [1260, 2736],
          [2736, 1260]
        ],
        ScreenSize::IOS_58 => [
          [1125, 2436],
          [2436, 1125]
        ],
        ScreenSize::IOS_61 => [
          [1080, 2340],
          [2340, 1080],
          [1170, 2532],
          [2532, 1170],
          [1179, 2556],
          [2556, 1179],
          [1206, 2622],
          [2622, 1206]
        ],
        ScreenSize::IOS_55 => [
          [1242, 2208],
          [2208, 1242]
        ],
        ScreenSize::IOS_47 => [
          [750, 1334],
          [1334, 750]
        ],
        ScreenSize::IOS_40 => [
          [640, 1096],
          [640, 1136],
          [1136, 600],
          [1136, 640]
        ],
        ScreenSize::IOS_35 => [
          [640, 920],
          [640, 960],
          [960, 600],
          [960, 640]
        ],
        ScreenSize::IOS_IPAD => [ # 9.7 inch
          [1024, 748],
          [1024, 768],
          [2048, 1496],
          [2048, 1536],
          [768, 1004], # portrait without status bar
          [768, 1024],
          [1536, 2008], # portrait without status bar
          [1536, 2048]
        ],
        ScreenSize::IOS_IPAD_10_5 => [
          [1668, 2224],
          [2224, 1668]
        ],
        ScreenSize::IOS_IPAD_11 => [
          [1668, 2420],
          [2420, 1668],
          [1668, 2388],
          [2388, 1668],
          [1640, 2360],
          [2360, 1640],
          [1488, 2266],
          [2266, 1488]
        ],
        ScreenSize::IOS_IPAD_PRO => [
          [2732, 2048],
          [2048, 2732]
        ],
        ScreenSize::IOS_IPAD_PRO_12_9 => [
          [2048, 2732],
          [2732, 2048],
          [2064, 2752],
          [2752, 2064]
        ],
        ScreenSize::MAC => [
          [1280, 800],
          [1440, 900],
          [2560, 1600],
          [2880, 1800]
        ],
        ScreenSize::IOS_APPLE_WATCH_SERIES_3 => [
          [312, 390]
        ],
        ScreenSize::IOS_APPLE_WATCH_SERIES_4 => [
          [368, 448]
        ],
        ScreenSize::IOS_APPLE_WATCH_SERIES_7 => [
          [396, 484]
        ],
        ScreenSize::IOS_APPLE_WATCH_SERIES_10 => [
          [416, 496]
        ],
        ScreenSize::IOS_APPLE_WATCH_ULTRA => [
          [410, 502],
          [422, 514]
        ],
        # Legacy mappings
        ScreenSize::IOS_APPLE_WATCH => [
          [312, 390]
        ],
        ScreenSize::APPLE_TV => [
          [1920, 1080],
          [3840, 2160]
        ],
        ScreenSize::APPLE_VISION_PRO => [
          [3840, 2160]
        ]
      }
    end

    def self.resolve_ipadpro_conflict_if_needed(screen_size, filename)
      is_3rd_gen = [
        "iPad Pro (12.9-inch) (3rd generation)", # Default simulator has this name
        "iPad Pro (12.9-inch) (4th generation)", # Default simulator has this name
        "iPad Pro (12.9-inch) (5th generation)", # Default simulator has this name
        "iPad Pro (12.9-inch) (6th generation)", # Default simulator has this name
        "IPAD_PRO_3GEN_129", # Screenshots downloaded from App Store Connect has this name
        "ipadPro129" # Legacy: screenshots downloaded from iTunes Connect used to have this name
      ].any? { |key| filename.include?(key) }
      if is_3rd_gen
        if screen_size == ScreenSize::IOS_IPAD_PRO
          return ScreenSize::IOS_IPAD_PRO_12_9
        elsif screen_size == ScreenSize::IOS_IPAD_PRO_MESSAGES
          return ScreenSize::IOS_IPAD_PRO_12_9_MESSAGES
        end
      end
      screen_size
    end

    def self.calculate_screen_size(path)
      size = FastImage.size(path)

      UI.user_error!("Could not find or parse file at path '#{path}'") if size.nil? || size.count == 0

      # iMessage screenshots have same resolution as app screenshots so we need to distinguish them
      path_component = Pathname.new(path).each_filename.to_a[-3]
      devices = path_component.eql?("iMessage") ? self.device_messages : self.devices

      devices.each do |screen_size, resolutions|
        if resolutions.include?(size)
          filename = Pathname.new(path).basename.to_s
          return resolve_ipadpro_conflict_if_needed(screen_size, filename)
        end
      end

      nil
    end
  end

  ScreenSize = AppScreenshot::ScreenSize
end
