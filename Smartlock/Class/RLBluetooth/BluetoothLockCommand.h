//
//  BluetoothLockCommand.h
//  Smartlock
//
//  Created by RivenL on 15/5/6.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLDate.h"

/*cmd*/
union union_mode {
    Byte common;
    Byte connection;
    Byte user_type;
    Byte broadcast_name_len;
    Byte keep;
};
struct BL_cmd {
    Byte ST;
    
    Byte cmd_code;
    union union_mode union_mode;
    
    union result {
        Byte keep;
        Byte result;
    }result;
    
    Byte data_len;
    Byte *data;
    
    Byte CRC;
    Byte END;
    
    Byte fixation_len;
};

extern Byte CRCOfCMDBytes(Byte *bytes, NSInteger len);
extern Byte STOfCMDBytes(Byte *bytes, NSInteger len);
extern Byte ENDOfCMDBytes(Byte *bytes, NSInteger len);

extern Byte BLcmdFixationLen();
extern struct BL_cmd getCMD(Byte cmdCode, union union_mode mode);
extern Byte CMDCRCCheck(struct BL_cmd *cmd);
extern Byte bytesCRCCheck(const Byte *data, NSInteger length);
extern Byte CMDDatasCRCCheck(const Byte *data, NSInteger length);
extern Byte *wrappCMDToBytes(struct BL_cmd *cmd, Byte bytes[]);
extern BOOL wrappCMDDatasToBytes(long long int *data, Byte bytes[], NSInteger len);
extern BOOL freeBLCMDData(const Byte *data);

extern Byte *dateToBytes(int * const len, NSString * const dateString);

//cmd response
typedef struct BL_cmd BL_response;

extern BL_response responseWithBytes(Byte *bytes, NSInteger length);
extern Byte cmdResponseCRCCheck(const Byte *data, NSInteger length);

@interface BluetoothLockCommand : NSObject

@end
