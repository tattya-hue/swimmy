module Swimmy
  module Resource
    class Member
      require "date"

      attr_reader :id, :name, :joined, :title, :account, :team, :mail, :phone, :birthday,
                  :google, :twitter, :github, :btmac, :organization

      def initialize(id, name, joined, title, account, team, mail, phone, birthday, google,
                     twitter, github, btmac, organization)

        @id, @name, @joined, @title, @account, @team, @mail, @phone, @google,
        @twitter, @github, @btmac, @organization = id, name, joined, title, account, team,
        mail, phone, google, twitter, github, btmac, organization

        begin
          @birthday = Date.parse(birthday)
        rescue ArgumentError
          @birthday = nil
        end
      end

      def active?
        /\d{4}[MBD]/ !~ self.title
      end

      def birthday?(date)
        return ((self.birthday != nil) && # whether birthday is nil or not
                (self.birthday.year <= date.year) && # whether the date isn't in the future
                (self.birthday.mon == date.mon) &&
                (self.birthday.mday == date.mday))
      end

      def match(keyword)
        regexp = Regexp.new(Regexp.quote(keyword), Regexp::IGNORECASE)

        self.to_s.split("\n").each do |s|
          return true if regexp =~ s.sub(/^[^:]+:\s*/, "")
        end
        return false
      end

      def to_s
        "ID: #{@id}\n" +
          "Name: #{@name}\n" +
          "Joined: #{@joined}\n" +
          "Title: #{@title}\n" +
          "Account: #{@account}\n" +
          "Team: #{@team}\n" +
          "Mail: #{@mail}\n" +
          "Phone: #{@phone}\n" +
          "Birthday: #{@birthday.strftime("%Y-%m-%d")}\n" +
          "Google: #{@google}\n" +
          "Twitter: #{@twitter}\n" +
          "GitHub: #{@github}\n" +
          "BtMAC: #{@btmac}\n" +
          "Organization: #{@organization}"
      end
    end # class Member
  end # module Resource
end # module Swimmy
