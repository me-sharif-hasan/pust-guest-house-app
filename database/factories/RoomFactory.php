<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Nette\Utils\Random;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Room>
 */
class RoomFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'number'=>(['101','102','103','201','202','203','301','302','303'])[random_int(0,100)%9],
            'guest_house_id'=>([1,2])[random_int(0,2312)%2],
            'room_type'=>(['AC','Non-AC'])[random_int(0,3123)%2],
        ];
    }
}
