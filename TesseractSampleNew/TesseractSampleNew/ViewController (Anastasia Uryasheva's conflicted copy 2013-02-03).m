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

@synthesize imageView, takePhotoBtn, choosePhotoBtn, nnewImage, analyzeButton, calendarButton, store, ourEvent, ourCalendar, monthArray, monthName, dayName;

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
    NSLog(@"%f%@%f", nnewImage.size.height, @" ", nnewImage.size.width);
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

-(void) saveToJpg:(UIImage *)image1
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	// If you go to the folder below, you will find those pictures
	NSLog(@"%@",docDir);
    
	NSLog(@"saving jpeg");
	NSString *jpegFilePath = [NSString stringWithFormat:@"%@/test.jpeg",docDir];
	NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image1, 1.0f)];//1.0f = 100% quality
	[data2 writeToFile:jpegFilePath atomically:YES];
}

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
    [tesseract recognize];
     NSLog(@"%@", [tesseract recognizedText]);
    [self writeResultToFile:[tesseract recognizedText]];
    NSString *resultString = [[NSString alloc] init];
//    resultString = [self readStringFromFile:<#(NSString *)#>]
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
                    NSDate *d = [mmddccyy dateFromString:@"02/02/2013 1:03:00"];
                    
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


//Function for taking Date from recognized text. Writes montg to variable monthName and day to dayName one. !! Isn't used anywhere still !!

-(void)takeDateFromTxt: (NSString*) str
{
    monthArray = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sept", @"Oct", @"Nov", @"Dec"];
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
                
                NSString *numberString;
                NSScanner *scanner = [NSScanner scannerWithString:foo[fooIndex+1]];
                NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
                [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
                [scanner scanCharactersFromSet:numbers intoString:&numberString];
                dayName = [numberString integerValue];
            }
        }
    }
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
