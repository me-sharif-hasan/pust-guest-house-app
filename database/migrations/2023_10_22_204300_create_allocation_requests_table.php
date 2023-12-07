<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('allocation_requests', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('guest_house_id');
            $table->unsignedBigInteger('room_id')->nullable();
            $table->string('bed_number')->nullable();
            $table->integer('guest_count')->default(1);
            $table->string('room_type');/*AC/NON-AC&*/
            $table->string('booking_type'); /*OFFICIAL/ PERSONAL*/
            $table->string('status')->nullable();
            $table->string('boarder_type')->nullable();
            $table->text("behalf_of")->nullable();
            $table->longText("rejection_reason")->nullable();
            $table->longText("cancellation_reason")->nullable();
            $table->string("allocation_purpose")->default("night_stay");
            $table->dateTime("boarding_date");
            $table->dateTime("departure_date");
            $table->dateTime('extension_request_date')->nullable();
            $table->boolean('is_admin_seen')->default(false);
            $table->boolean('is_user_seen')->default(false);
            $table->string('token')->unique()->index()->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('allocation_requests');
    }
};
