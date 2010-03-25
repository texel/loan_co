class DisclosureForm < ActiveRecord::Base
  PDF_PATH = Rails.root.join('public/docs/disclosure.pdf')
  
  validates_presence_of :first_name, :last_name, :address_1, :city, :state, :zip, :phone, :email
  
  def signer
    @signer ||= Docusign::Recipient.new.tap do |s|
      s.id        = 1
      s.email     = email
      s.user_name = full_name
      s.type      = Docusign::RecipientTypeCode::Signer
      
      s.require_id_lookup = false
      
      s.captive_info = Docusign::RecipientCaptiveInfo.new.tap do |i|
        i.client_user_id = Time.now.to_i
      end
      
      s.signature_info = Docusign::RecipientSignatureInfo.new.tap do |i|
        i.signature_initials = initials
        i.font_style         = Docusign::FontStyleCode::Mistral
        i.signature_name     = full_name
      end
    end
  end
  
  def document
    @document ||= Docusign::Document.new.tap do |d|
      d.id = 1
      d.name = 'disclosure'
      d.pdf_bytes = Base64.encode64(File.read(PDF_PATH))
      
      # Create tabs
      d.tabs signer do |d|
        d.tab :name => 'email',     :value => email,      :page => 1, :x => 190, :y => 186
        d.tab :name => 'phone',     :value => phone,      :page => 1, :x => 190, :y => 173
        d.tab :name => 'zip',       :value => zip,        :page => 1, :x => 342, :y => 160
        d.tab :name => 'state',     :value => state,      :page => 1, :x => 255, :y => 160
        d.tab :name => 'city',      :value => city,       :page => 1, :x => 190, :y => 160
        d.tab :name => 'address_1', :value => address_1,  :page => 1, :x => 190, :y => 134
        d.tab :name => 'address_2', :value => address_2,  :page => 1, :x => 190, :y => 147
                                                          
        d.tab :type => Docusign::TabTypeCode::FullName,   :page => 1, :x => 190, :y => 118
        d.tab :type => Docusign::TabTypeCode::SignHere,   :page => 1, :x => 373, :y => 185
        
        d.tab :type => Docusign::TabTypeCode::DateSigned, :page => 2, :x => 190, :y => 532
        d.tab :type => Docusign::TabTypeCode::InitialHereOptional, :page => 2, :x => 190, :y => 465
      end
    end
  end
  
  def envelope
    @envelope ||= Docusign::Envelope.new.tap do |e|
      e.recipients  = [signer]
      e.documents   = [document]
      e.tabs        = document.tabs
      e.subject     = 'Disclosure Form'
      e.email_blurb = 'Sign the disclosure form to submit.'
      e.account_id  = Docusign::Config[:account_id]
    end
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def initials
    full_name.split(' ').map(&:first).map(&:upcase).join
  end
  
  def address_2
    self[:address_2].blank? ? '&nbsp' : self[:address_2]
  end
end
