class Api::V1::S3StoragesController < ApplicationController
  # Used to run loadClient before anything else is run
  before_action :loadS3Client

  # Loads AWS s3 client
  def loadS3Client()
    @s3Client = Aws::S3::Client.new(access_key_id: ENV['h_aws_access_key_id'],secret_access_key: ENV['h_aws_secret_access_key'],region: 'us-east-1')

  end

  def s3upload()

    @resp = @s3Client.put_object(
      acl: "bucket-owner-full-control",
      body: "this is a test",
      # required
      bucket: "tcnj-csc470-harveyh1",
      # cache_control: "CacheControl",
      # content_disposition: "ContentDisposition",
      # content_encoding: "ContentEncoding",
      # content_language: "ContentLanguage",
      # content_length: 1,
      # content_md5: "ContentMD5",
      # content_type: "ContentType",
      # expires: Time.now,
      # grant_full_control: "GrantFullControl",
      # grant_read: "GrantRead",
      # grant_read_acp: "GrantReadACP",
      # grant_write_acp: "GrantWriteACP",
      # required
      key: "test.txt",
      # metadata: { "MetadataKey" => "MetadataValue" },
      #server_side_encryption: "AES256",
      storage_class: "STANDARD",
      website_redirect_location: "http://www.hankharvey.com",
      # sse_customer_algorithm: "SSECustomerAlgorithm",
      # sse_customer_key: "SSECustomerKey",
      # sse_customer_key_md5: "SSECustomerKeyMD5",
      # ssekms_key_id: "SSEKMSKeyId",
    )


    #Used to get send quote
    @resp.each do |response|
      @resp = response.data
    end

  end
end
