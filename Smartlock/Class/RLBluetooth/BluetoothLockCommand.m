//
//  BluetoothLockCommand.m
//  Smartlock
//
//  Created by RivenL on 15/5/6.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "BluetoothLockCommand.h"

Byte CRCOfCMDBytes(Byte *bytes, NSInteger len) {
    if(!len || len < 2 || !bytes) {
        return 0x00;
    }
    
    return bytes[len-2];
}
Byte STOfCMDBytes(Byte *bytes, NSInteger len) {
    if(!len || !bytes) {
        return 0x00;
    }
    
    return bytes[0];
}
Byte ENDOfCMDBytes(Byte *bytes, NSInteger len) {
    if(!len || len < 1 || !bytes) {
        return 0x00;
    }
    
    return bytes[len-1];
}


Byte BLcmdFixationLen() {
    return 7;
}

struct BL_cmd getCMD(Byte cmdCode, union union_mode mode) {
    struct BL_cmd cmd = {0};
    
    cmd.ST = 0x55;
    cmd.cmd_code = cmdCode;
    cmd.union_mode.common = mode.common;
    cmd.result.keep = 0x00;
    cmd.END = 0x66;
    
    cmd.fixation_len = BLcmdFixationLen();
    
    return cmd;
}

Byte CMDCRCCheck(struct BL_cmd *cmd) {
    Byte crc = 0x00;
    if(!cmd)
        return crc;
    
    crc += cmd->ST;
    crc += cmd->cmd_code;
    crc += cmd->union_mode.connection;
    crc += cmd->result.keep;
    
    crc += cmd->data_len;
    
    crc += CMDDatasCRCCheck(cmd->data, cmd->data_len);
//    cmd->CRC = crc;
    
    return crc;
}

Byte bytesCRCCheck(const Byte *data, NSInteger length) {
    if(!data || !length) {
        return 0x00;
    }
    Byte crcTemp = 0x00;
    for(NSInteger i=0; i<length; i++) {
        crcTemp += data[i];
    }
    
    return crcTemp;
}

Byte CMDDatasCRCCheck(const Byte *data, NSInteger length) {
    return bytesCRCCheck(data, length);
}

Byte *wrappCMDToBytes(struct BL_cmd *cmd, Byte bytes[]) {
    if(!cmd || !bytes)
        return NULL;
    NSInteger i=0;
    bytes[i++] = cmd->ST;
    bytes[i++] = cmd->cmd_code;
    bytes[i++] = cmd->union_mode.common;
    bytes[i++] = cmd->result.keep;
    bytes[i++] = cmd->data_len;
    for(NSInteger j=i; i<j+cmd->data_len; i++) {
        bytes[i] = cmd->data[i-j];
    }
    bytes[i++] = cmd->CRC;
    bytes[i] = cmd->END;
    
    return bytes;
}

BOOL wrappCMDDatasToBytes(long long int *data, Byte bytes[], NSInteger len) {
    if(!data || !bytes || sizeof(long long int) != len) {
        return NO;
    }
    
    bytes = (UInt8 *)&data;
    
    return YES;
}

BOOL freeBLCMDData(const Byte *data) {
    if(data) {
        free((void *)data);
    }
    
    return YES;
}

//extern int datasForCMD(Byte *datas, int *len, struct BL_cmd *cmd) {
//    if(datas == nil || len == nil || cmd == nil) {
//        return -1;
//    }
//    
//    
//}

static Byte date[6] = {0};
void fillDateDatas(Byte *dateDatas, int len, NSDateComponents *dateComponents) {
    int i = 0;
    dateDatas[i++] = dateComponents.year - 2000;
    dateDatas[i++] = dateComponents.month;
    dateDatas[i++] = dateComponents.day;
    dateDatas[i++] = dateComponents.hour;
    dateDatas[i++] = dateComponents.minute;
    dateDatas[i] = dateComponents.second;
}

Byte *dateToBytes(int * const len, NSString * const dateString) {
    if(!len || !dateString || dateString.length == 0)
        return NULL;
    NSDateComponents *dateComponents = [RLDate dateComponentsWithDate:[RLDate dateFromString:dateString]];
    *len = sizeof(date);
    fillDateDatas(date, *len, dateComponents);
    
    return date;
}

Byte *dateNowToBytes(int * const len) {
    if(!len)
        return NULL;
    NSDateComponents *dateComponents = [RLDate dateComponentsNow];
    *len = sizeof(date);
    
    fillDateDatas(date, *len, dateComponents);
    
    return date;
}

#pragma mark -
//cmd response
static Byte BL_responseData[240] = {0};
BL_response responseWithBytes(Byte *bytes, NSInteger length) {
    BL_response response = {0};
    if(bytes && length) {
        NSInteger i=0;
        response.ST = bytes[i++];
        response.cmd_code = bytes[i++];
        response.union_mode.common = bytes[i++];
        response.result.result = bytes[i++];
        response.data_len = bytes[i++];
        memset(BL_responseData, 0, sizeof(BL_responseData));
        for(NSInteger j=i; i<j+response.data_len; i++) {
            BL_responseData[i-j] = bytes[i];
        }
        response.data = BL_responseData;
        response.CRC = bytes[length-2];
        response.END = bytes[length-1];
        response.fixation_len = BLcmdFixationLen();
    }
    return response;
}

Byte cmdResponseCRCCheck(const Byte *data, NSInteger length) {
    return CMDDatasCRCCheck(data, length);
}

@implementation BluetoothLockCommand
- (void)test {
    
}
@end
