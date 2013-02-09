//
//  ViewController.m
//  TesseractSampleNew
//
//  Created by Anastasia Uryasheva on 1/31/13.
//  Copyright (c) 2013 Anastasia Uryasheva. All rights reserved.
//

#import "tesseract.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageView, takePhotoBtn, choosePhotoBtn, nnewImage, analyzeButton, calendarButton, store, ourEvent, ourCalendar, monthArray, monthName, dayName, mmonthName, timeArray, amountOfHours, hoursAm, resu, titlestring;

// Working with camera
-(IBAction) getPhoto:(id) sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	[self presentViewController:picker animated:YES completion:^{NSLog(@"ololo");}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:^{NSLog(@"ololo");}];
	nnewImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //NSLog(@"%f%@%f", nnewImage.size.height, @" ", nnewImage.size.width);
    imageView.image = nnewImage;
//    [tesseract setImage:nnewImage];
}

// Reading something from txt file
- (NSString *)readStringFromFile:(NSString*) nameOfFile{
    
    // Build the path...
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString* fileName = @"myTextFile.txt";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:nameOfFile];
    NSString * newres = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
    return newres;
}

// Button analyze - recognize text from file and writes it to file
- (BOOL)imageFunc:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

//Saves NSData to jpg
-(void) saveToJpg:(UIImage *)image1
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	// If you go to the folder below, you will find those pictures
	//NSLog(@"%@",docDir);
    
	//NSLog(@"saving jpeg");
	NSString *jpegFilePath = [NSString stringWithFormat:@"%@/test.jpeg",docDir];
	NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image1, 1.0f)];//1.0f = 100% quality
	[data2 writeToFile:jpegFilePath atomically:YES];
}

//Main function which analyzes posters
-(IBAction)analyze:(id)sender{
//    UIImage* olo = [UIImage imageNamed:@"image_sample.jpg"];
/*   if ([self imageFunc:nnewImage  isEqualTo:[UIImage imageNamed:@"image_sample.jpg"]])
       NSLog(@"RABOTAET");
    [self saveToJpg:nnewImage];
    UIImage * oloImage = [UIImage imageNamed:@"image_sample.jpg"];
    if (nnewImage.imageOrientation == oloImage.imageOrientation)
        NSLog(@"ORIENT");
    if (nnewImage.size.height == oloImage.size.height && nnewImage.size.width == oloImage.size.width)
        NSLog(@"SIZE");
    if (nnewImage.scale == oloImage.scale)
        NSLog(@"SCALE");*/
    
//    if ([self imageFunc:nnewImage  isEqualTo:oloImage])
//        NSLog(@"RABOTAET");
//    UIImage *imageToDisplay =[UIImage imageWithCGImage:[nnewImage CGImage] scale:1.0 orientation: UIImageOrientationUp];
    [tesseract setImage:nnewImage];
    imageView.image = nnewImage;
//    [tesseract setImage:nnewImage];
    [tesseract recognize];
     NSLog(@"%@", [tesseract recognizedText]);
    [self writeResultToFile:[tesseract recognizedText]];
    NSString *resultString = [[NSString alloc] init];
    resultString = [self readStringFromFile:@"myTextFile.txt"];
    [self takeDateFromTxt:resultString];
    UIAlertView *alertDate = [[UIAlertView alloc]
                          initWithTitle:@"Date of event"
                              message:[NSString stringWithFormat:@"%@%@%d%@", monthName, @" ", dayName, @", 2013"]
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];

    [self takeTimeFromTxt:resultString];
    
    UIAlertView *alertTime = [[UIAlertView alloc]
                              initWithTitle:@"Time of the beggining"
                              message:[NSString stringWithFormat:@"%@%@", hoursAm[0], @" pm"]
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];


    [tesseract setImage:[UIImage imageNamed:@"image_sample_resized.jpg"]];
    [tesseract recognize];
    NSLog(@"%@", [tesseract recognizedText]);
    [self writeResultToFile:[tesseract recognizedText]];
    NSString *resultStringResized = [[NSString alloc] init];
    resultStringResized = [self readStringFromFile:@"myTextFile.txt"];
    [self findTitle:resultString :resultStringResized];
    
    UIAlertView *alertTitle = [[UIAlertView alloc]
                              initWithTitle:@"Event name"
                              message:[NSString stringWithFormat:@"%@", titlestring]
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
    [alertTitle show];
    
    [alertTime show];

    
    
    [alertDate show];


    
//    NSLog(@"%@", mmonthName);
//    NSLog (@"%d", dayName);
//    NSString * kirpich = [[NSString alloc] init];
//    kirpich =[self readStringFromFile:@"myTextFile.txt"];
//    NSLog(@"%@", kirpich);
//    ololo = readStringFromFile:@"myTextFile.txt";
    
}


// Writing something to txt file
-(void) writeResultToFile:(NSString *)str
{
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"myTextFile.txt";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    [[str dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}


//Function for writing event to calendar.
-(IBAction)calendarOlo:(id)sender{
    store = [[EKEventStore alloc] init];
    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    NSLog(@"Error with access");
                }
                else if (!granted)
                {
                    NSLog(@"Access wasn't granted");
                }
                else
                {
                    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
                    mmddccyy.timeStyle = NSDateFormatterNoStyle;
                    mmddccyy.dateFormat = @"MM/dd/yyyy hh:mm:ss";
                    
                    NSString * datenow = [NSString stringWithFormat:@"%@%@%d%@", mmonthName, @"/", dayName, @"/2013 1:03:00"];
                    NSLog(@"%@", datenow);
                    NSDate *d = [mmddccyy dateFromString:datenow];
                    
                    NSLog(@"Access granted - work with ios6");
                    ourEvent = [EKEvent eventWithEventStore:store];
                    ourEvent.title = @"new event";
                    ourEvent.startDate = d;
                    ourEvent.endDate = [[NSDate alloc] initWithTimeInterval:3600 sinceDate:d];
                    ourEvent.allDay = YES;
                    [ourEvent setCalendar:[store defaultCalendarForNewEvents]];
                    NSError * err;
                    [store saveEvent:ourEvent span:EKSpanThisEvent error:&err];
                    if (err == NULL) {
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Event Created"
                                              message:@"Yay!"
                                              delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    
                    // ***** do the important stuff here *****
                }
            });
        }];
    }
    else
    {
        NSLog(@"Work with ios4 or ios5");
        // this code runs in iOS 4 or iOS 5
        // ***** do the important stuff here *****
    }
    

}


//Function for taking Date from recognized text. Writes month to variable monthName and day to dayName one.
-(void)takeDateFromTxt: (NSString*) str
{
    //case if we have date in format November, 15th
    monthArray = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sept", @"Oct", @"Nov", @"Dec"];
    dayName = -1;
    NSArray* foo = [str componentsSeparatedByString: @" "];
    for (NSString * str1 in foo)
    {
        for (NSString *subStr in monthArray)
        {
            NSRange result = [str1 rangeOfString:subStr];
            if(result.location != NSNotFound)
            {
                NSUInteger fooIndex = [foo indexOfObject: str1];
                monthName = str1;
                if ([subStr isEqualToString:@"Jan"])
                    mmonthName = @"01";
                else if ([subStr isEqualToString:@"Feb"])
                    mmonthName = @"02";
                else if ([subStr isEqualToString:@"Mar"])
                    mmonthName = @"03";
                else if ([subStr isEqualToString:@"Apr"])
                    mmonthName = @"04";
                else if ([subStr isEqualToString:@"May"])
                    mmonthName = @"05";
                else if ([subStr isEqualToString:@"Jun"])
                    mmonthName = @"06";
                else if ([subStr isEqualToString:@"Jul"])
                    mmonthName = @"07";
                else if ([subStr isEqualToString:@"Aug"])
                    mmonthName = @"08";
                else if ([subStr isEqualToString:@"Sept"])
                    mmonthName = @"09";
                else if ([subStr isEqualToString:@"Oct"])
                    mmonthName = @"10";
                else if ([subStr isEqualToString:@"Nov"])
                    mmonthName = @"11";
                else if ([subStr isEqualToString:@"Dec"])
                    mmonthName = @"12";
                
                NSString *numberString;
                NSScanner *scanner = [NSScanner scannerWithString:foo[fooIndex+1]];
                NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
                [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
                [scanner scanCharactersFromSet:numbers intoString:&numberString];
                dayName = [numberString integerValue];
                
                if (dayName != -1)
                    goto endoffunc;
            }
        }
    }
    if (dayName == -1)
    {
        for (NSString* str1 in foo)
        {
            NSString *numberString;
            int ololtemp;
            NSScanner *scannerStrWithDots = [NSScanner scannerWithString:str1];
            NSCharacterSet *numbersRes = [NSCharacterSet characterSetWithCharactersInString:@"0123456789./"];
            [scannerStrWithDots scanUpToCharactersFromSet:numbersRes intoString:NULL];
            [scannerStrWithDots scanCharactersFromSet:numbersRes intoString:&numberString];
            if (numberString!=NULL)
            {
                ololtemp = [numberString integerValue];
                if (ololtemp > 0 && ololtemp<13)
                {
                    if ([numberString rangeOfString:@"."].location != NSNotFound)
                    {
                        NSArray* divByDots = [[NSArray alloc] init];
                        divByDots = [numberString componentsSeparatedByString: @"."];
                        if ([divByDots count] == 2 || [divByDots count] == 3)
                        {
                            if([divByDots[0] integerValue] > 0 && [divByDots[0] integerValue] < 13 && [divByDots[1] integerValue] > 0 && [divByDots[1] integerValue] < 32)
                            {
                                monthName = divByDots[0];
                                dayName = [divByDots[1] integerValue];
                                goto endoffunc;
                            }
                        }
                    }
                    else if ([numberString rangeOfString:@"/"].location != NSNotFound)
                    {
                        NSArray* divBySlash = [[NSArray alloc] init];
                        divBySlash = [numberString componentsSeparatedByString: @"/"];
                        if ([divBySlash count] == 2 || [divBySlash count] == 3)
                        {
                            if([divBySlash[0] integerValue] > 0 && [divBySlash[0] integerValue] < 13 && [divBySlash[1] integerValue] > 0 && [divBySlash[1] integerValue] < 32)
                            {
                                monthName = divBySlash[0];
                                dayName = [divBySlash[1] integerValue];
                                goto endoffunc;
                            }
                        }
                    }
                }
            }
        }
    }
endoffunc:
    NSLog(@"%@%d", monthName, dayName);
}

//Function for taking Time from txt - writes it to array hoursAM
-(void)takeTimeFromTxt: (NSString*) str
{
    hoursAm = [[NSMutableArray alloc] initWithCapacity:30];
    timeArray = @[@"pm", @"am", @"p.m.", @"a.m."];
    NSArray* foo = [str componentsSeparatedByString: @" "];
    for (NSString * str1 in foo)
    {
        for (NSString *subStr in timeArray)
        {
            NSRange result = [str1 rangeOfString:subStr];
            if(result.location != NSNotFound) //{NSLog(@"Yes, it is substring");}
            {
                for (int i=0; i<[str1 length]; i++)
                    if ([str1 characterAtIndex:i] == 'p' || [str1 characterAtIndex:i] == 'a')
                    {
                        if ([str1 characterAtIndex:i+1] == 'm')
                        {
                            if ((i+2)!=[str1 length])
                            {
                            if ((int)[str1 characterAtIndex:i+2]<48 || ((int)[str1 characterAtIndex:i+2]>57 && (int)[str1 characterAtIndex:i+2]<97) || (int)[str1 characterAtIndex:i+2]>122)
                            {
                                NSUInteger pos = [str1 rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
                                amountOfHours += ((int)[str1 characterAtIndex:pos] - 48);
                                pos+=1;
                                if ((int)[str1 characterAtIndex:pos] >= 48 && (int)[str1 characterAtIndex:pos]<=57 )
                                {
                                    NSUInteger hours = amountOfHours*10;
                                    amountOfHours = hours + ((int)[str1 characterAtIndex:pos] - 48);
                                }
                                NSNumber* xWrapped = [NSNumber numberWithInt:amountOfHours];
                                [hoursAm addObject:xWrapped];
                            }
                            else if ([str1 characterAtIndex:i+1] == '.')
                                if ([str1 characterAtIndex:i+1] == 'm')
                                    NSLog(@"OLOLO");
                            }
                            else
                            {
                                NSUInteger pos = [str1 rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
                                if (pos>=0 && pos< [str1 length])
                                {
                                    amountOfHours += ((int)[str1 characterAtIndex:pos] - 48);
                                    pos+=1;
                                    if ((int)[str1 characterAtIndex:pos] >= 48 && (int)[str1 characterAtIndex:pos]<=57 )
                                    {
                                        NSUInteger hours = amountOfHours*10;
                                        amountOfHours = hours + ((int)[str1 characterAtIndex:pos] - 48);
                                    }
                                    NSNumber* xWrapped = [NSNumber numberWithInt:amountOfHours];
                                    [hoursAm addObject:xWrapped];
                                    break;
                                }

                            }
                        }
                        
                    }

            }
        }
    }
//    NSLog(@"%@", hoursAm[0]);
}

//finds Title from th text. Takes two posters - original and resized
- (void)findTitle:(NSString*)original :(NSString*)resized
{
    NSUInteger numberOfEl;
    NSArray* originalArr = [original componentsSeparatedByString: @" "];
    NSArray* resizedArr = [resized componentsSeparatedByString:@" "];
    NSCharacterSet *charactersToRemove =
    [[ NSCharacterSet alphanumericCharacterSet ] invertedSet ];
    resu = [[NSMutableArray alloc] initWithCapacity:30];
    for (NSString* strRes in resizedArr)
    {
        NSString *trimmedRes = [[ strRes componentsSeparatedByCharactersInSet:charactersToRemove ]
                                componentsJoinedByString:@""];
        NSString *strNewRes = [trimmedRes stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        for (NSString* strOr in originalArr)
        {
            NSString *trimmedOrig = [[ strOr componentsSeparatedByCharactersInSet:charactersToRemove ]
                                     componentsJoinedByString:@""];
            NSString *strNewOrig = [trimmedOrig stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            //NSLog(@"%@%@%@", strNewOrig, @" ", strNewRes);
            if ([strNewRes isEqualToString: strNewOrig] && ![strNewRes isEqual: @""] && ![strNewOrig isEqual: @""])
            {
                numberOfEl = [originalArr indexOfObject: strOr];
                NSNumber *xWrapped = [NSNumber numberWithInt:numberOfEl];
                //NSLog(@"%@",xWrapped);
                [resu addObject:xWrapped];
                //NSLog(@"%@", [resu lastObject]);
                // NSLog(@"%@", originalArr[numberOfEl]);
                // break;
            }
        }
    }
    
    //[NSString stringWithFormat:@"%@%@%@", originalArr[numberOfEl], originalArr[numberOfEl+1], originalArr[numberOfEl+2]];
    int t = [resu[0] intValue];
    //NSLog(@"%d", t);
    
    titlestring = [NSString stringWithFormat:@"%@%@%@%@%@", originalArr[t], @" ", originalArr[t+1], @" ", originalArr[t+2]];
    NSLog(@"%@%@%@%@%@", originalArr[t], @" ", originalArr[t+1], @" ", originalArr[t+2]);
}

- (void)viewDidLoad
{
    tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
//    [tesseract setImage:[UIImage imageNamed:@"image_sample.jpg"]];
//    [tesseract recognize];
    
//    NSLog(@"%@", [tesseract recognizedText]);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
