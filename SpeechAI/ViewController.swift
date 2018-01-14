//
//  ViewController.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    func speechGenerator() -> String {
        var speeches = ["We have also come to this hallowed spot to remind America of the fierce urgency of Now. This is no time to engage in the luxury of cooling off or to take the tranquilizing drug of gradualism. Now is the time to make real the promises of democracy. Now is the time to rise from the dark and desolate valley of segregation to the sunlit path of racial justice. Now is the time to lift our nation from the quicksands of racial injustice to the solid rock of brotherhood. Now is the time to make justice a reality for all of God's children.",
                        "But there is something that I must say to my people, who stand on the warm threshold which leads into the palace of justice: In the process of gaining our rightful place, we must not be guilty of wrongful deeds. Let us not seek to satisfy our thirst for freedom by drinking from the cup of bitterness and hatred. We must forever conduct our struggle on the high plane of dignity and discipline. We must not allow our creative protest to degenerate into physical violence. Again and again, we must rise to the majestic heights of meeting physical force with soul force.",
                        "The marvelous new militancy which has engulfed the Negro community must not lead us to a distrust of all white people, for many of our white brothers, as evidenced by their presence here today, have come to realize that their destiny is tied up with our destiny. And they have come to realize that their freedom is inextricably bound to our freedom.",
                        "On behalf of the great Empire State and the whole family of New York, let me thank you for the great privilege of being able to address this convention. Please allow me to skip the stories and the poetry and the temptation to deal in nice but vague rhetoric. Let me instead use this valuable opportunity to deal immediately with the questions that should determine this election and that we all know are vital to the American people.",
                        "But the hard truth is that not everyone is sharing in this city's splendor and glory. A shining city is perhaps all the President sees from the portico of the White House and the veranda of his ranch, where everyone seems to be doing well. But there's another city; there's another part to the shining the city; the part where some people can't pay their mortgages, and most young people can't afford one; where students can't afford the education they need, and middle-class parents watch the dreams they hold for their children evaporate.",
                        "On the third of February last I officially laid before you the extraordinary announcement of the Imperial German Government that on and after the first day of February it was its purpose to put aside all restraints of law or of humanity and use its submarines to sink every vessel that sought to approach either the ports of Great Britain and Ireland or the western coasts of Europe or any of the ports controlled by the enemies of Germany within the Mediterranean."]
        let randomIndex = Int(arc4random_uniform(UInt32(speeches.count)))
        return speeches[randomIndex]
    }
}

