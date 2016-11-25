//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//
#import <OEZCommSDK/OEZCommSDK.h>

#pragma pack(1)
struct SocketPacketHead {
    UInt16 packet_length;
    UInt8 is_zip_encrypt;
    UInt8 type ;
    UInt16 signature;
    UInt16 operate_code;
    UInt16 data_length;
    UInt32 timestamp ;
    UInt64 session_id ;
    UInt32 request_id ;
};
#pragma pack()
#import <Qiniu/QiniuSDK.h>