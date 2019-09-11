//
//  TableArray.swift
//  Chat
//
//  Created by Niid tech on 10/03/18.
//  Copyright © 2018 NiidTechnology. All rights reserved.
//

import UIKit

class TableArray: NSObject {

    
    var mapTitleToMessages = [String: Any]()
    var orderedTitles = [String]()
//    var numberOfSections: Int = 0
//    var numberOfMessages: Int = 0
//    var formatter: DateFormatter?
    
//    @property (strong, nonatomic) NSMutableDictionary *mapTitleToMessages;
//    @property (strong, nonatomic) NSArray *orderedTitles;
//    @property (assign, nonatomic) NSInteger numberOfSections;
//    @property (assign, nonatomic) NSInteger numberOfMessages;
//    @property (strong, nonatomic) NSDateFormatter *formatter;
    
    
//    -(void)addObject:(Message *)message;
//    -(void)addObjectsFromArray:(NSArray *)messages;
//    -(void)removeObject:(Message *)message;
//    -(void)removeObjectsInArray:(NSArray *)messages;
//    -(void)removeAllObjects;
//    -(NSInteger)numberOfMessages;
//    -(NSInteger)numberOfSections;
//    -(NSInteger)numberOfMessagesInSection:(NSInteger)section;
//    -(NSString *)titleForSection:(NSInteger)section;
//    -(Message *)objectAtIndexPath:(NSIndexPath *)indexPath;
//    -(Message *)lastObject;
//    -(NSIndexPath *)indexPathForLastMessage;
//    -(NSIndexPath *)indexPathForMessage:(Message *)message;
    
    func addObject(message : Message) -> Void {
        
    }
//    -(void)addObject:(Message *)message
//    {
//    return [self addMessage:message];
//    }
    
    func addObjectsFromArray(messages :[Message]) -> Void {
//        for var i in 0..<messages.count

        for var message in messages
        {
            
        }
    }
//    -(void)addObjectsFromArray:(NSArray *)messages
//    {
//    for (Message *message in messages)
//    {
//    [self addMessage:message];
//    }
//    }
    
    func removeObject(message : Message) -> Void {
        
    }
    
//    -(void)removeObject:(Message *)message
//    {
//    [self removeMessage:message];
//    }
    
    func removeObjectsInArray(messages :[Message]) -> Void {
        for var message in messages
        {
            
        }
    }
    
//    -(void)removeObjectsInArray:(NSArray *)messages
//    {
//    for (Message *message in messages)
//    {
//    [self removeMessage:message];
//    }
//    }
    func removeAllObjects() -> Void {
        self.mapTitleToMessages .removeAll()
        self.orderedTitles = []
    }
    
    
//    -(void)removeAllObjects
//    {
//    [self.mapTitleToMessages removeAllObjects];
//    self.orderedTitles = nil;
//    }
    var numberOfMessages: Int {
        return self.numberOfMessages
    }
    
    var numberOfSections: Int {
        return self.numberOfSections
    }
    
    func numberOfMessagesInSection(section :Int) -> Int {
        
        if self.orderedTitles.count == 0 {
            return 0
        }else{
            let key: String = orderedTitles[section] as! String
            let array = mapTitleToMessages[key] as? [[String: Any]] ?? [[String: Any]]()
//            let array = mapTitleToMessages.value(forKey: key) //as? [Any]
            return array.count
        }
        
       
    }
//    -(NSInteger)numberOfMessagesInSection:(NSInteger)section
//    {
//    if (self.orderedTitles.count == 0) return 0;
//    NSString *key = self.orderedTitles[section];
//    NSArray *array = [self.mapTitleToMessages valueForKey:key];
//    return array.count;
//    }
    func titleForSection(section :Int) -> String {
        let formatter : DateFormatter = self.formatter.copy() as! DateFormatter
        let key = self.orderedTitles[section]
        let date = formatter.date(from: key as! String)
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: date!)
    }
    
    
    
//    -(NSString *)titleForSection:(NSInteger)section
//    {
//    NSDateFormatter *formatter = [self.formatter copy];
//    NSString *key = self.orderedTitles[section];
//    NSDate *date = [formatter dateFromString:key];
//
//    formatter.doesRelativeDateFormatting = YES;
//    return [formatter stringFromDate:date];
//    }
    
    func objectAtIndexPath(indexPath :IndexPath) -> Message {
        let key = self.orderedTitles[indexPath.section] as! String
        let array = mapTitleToMessages[key] as! [Message] ///as? [[Message]] ?? [[Message]]()
        return array[indexPath.row] //as Message
    }
//    -(Message *)objectAtIndexPath:(NSIndexPath *)indexPath
//    {
//    NSString *key = self.orderedTitles[indexPath.section];
//    NSArray *array = [self.mapTitleToMessages valueForKey:key];
//    return array[indexPath.row];
//    }
    
//    var lastObject: Message {
//        let indexPath : IndexPath = self
//
//    }
    
    
//    -(Message *)lastObject
//    {
//    NSIndexPath *indexPath = [self indexPathForLastMessage];
//    return [self objectAtIndexPath:indexPath];
//    }
    
    
//    -(NSIndexPath *)indexPathForLastMessage
//    {
//    NSInteger lastSection = _numberOfSections-1;
//    NSInteger numberOfMessages = [self numberOfMessagesInSection:lastSection];
//    return [NSIndexPath indexPathForRow:numberOfMessages-1 inSection:lastSection];
//    }
    
    
//    func indexPathForMessage(message :Message) -> IndexPath {
//        
//        let key = self.keyForMessage(message: message)
//        let section : Int = self.orderedTitles.index(of: key)
////        let row = self.mapTitleToMessages[key] //as? [[String: Any]] ?? [[String: Any]]()
////        let row = [self.mapTitleToMessages[key]].inde
////        var row: Int? = (self.mapTitleToMessages[key]? as! NSArray).index(of: message)
//        let row: Int? = (self.mapTitleToMessages[key]? as Dictionary).index(of: message)
//        ;
//        let indexpath:IndexPath = IndexPath.init(row: row, section:section )
//        
//        return indexpath
//    }
//    -(NSIndexPath *)indexPathForMessage:(Message *)message
//    {
//    NSString *key = [self keyForMessage:message];
//    NSInteger section = [self.orderedTitles indexOfObject:key];
//    NSInteger row = [[self.mapTitleToMessages valueForKey:key] indexOfObject:message];
//    return [NSIndexPath indexPathForRow:row inSection:section];
//    }

    
    func keyForMessage(message :Message) -> String {
        let date = NSDate() as Date//
        return self.formatter .string(from: date)
    }
//    -(NSString *)keyForMessage:(Message *)message
//    {
//    return [self.formatter stringFromDate:message.date];
//    }

    
    var formatter: DateFormatter {

       let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.none
        formatter.dateStyle = DateFormatter.Style.short
        formatter.doesRelativeDateFormatting = false
        
        return formatter
    }
    //    -(NSDateFormatter *)formatter
    //    {
    //    if (!_formatter)
    //    {
    //    _formatter = [[NSDateFormatter alloc] init];
    //    _formatter.timeStyle = NSDateFormatterNoStyle;
    //    _formatter.dateStyle = NSDateFormatterShortStyle;
    //    _formatter.doesRelativeDateFormatting = NO;
    //
    //    }
    //    return _formatter;
    //    }
    
}
