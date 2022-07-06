//
//  AppDelegate.h
//  AudioMixing
//
//  Created by Daniel Flores Garcia on 7/6/22.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

