GPU=$[$WORLD_SIZE * 8]
echo GPU=${GPU}
echo WORLD_SIZE=$WORLD_SIZE
echo RANK=$RANK
echo MASTER_ADDR=$MASTER_ADDR
echo MASTER_PORT=$MASTER_PORT

WANDB_MODE=offline deepspeed llava/train/train_mem_CoS.py \
    --deepspeed ./scripts/zero3.json \
    --model_name_or_path ./checkpoints/llava-v1.5-7b-ckpt \
    --version v1 \
    --data_path ./playground/data/llava_v1_5_mix665k.json \
    --IR_data_path /PATH/TO/YOUR/DATA \
    --image_folder ./playground/data \
    --vision_tower openai/clip-vit-large-patch14-336 \
    --pretrain_mm_mlp_adapter ./checkpoints/llava-v1.5-7b-ckpt/mm_projector.bin \
    --mm_projector_type mlp2x_gelu \
    --mm_vision_select_layer -2 \
    --mm_use_im_start_end False \
    --mm_use_im_patch_token False \
    --image_aspect_ratio pad \
    --group_by_modality_length True \
    --bf16 True \
    --output_dir ./checkpoints/llava-v1.5-7b-CoS \
    --num_train_epochs 1 \
    --per_device_train_batch_size 16 \
    --per_device_eval_batch_size 4 \
    --gradient_accumulation_steps 1 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 50000 \
    --save_total_limit 1 \
    --learning_rate 2e-5 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --tf32 True \
    --model_max_length 2048 \
    --gradient_checkpointing True \
    --dataloader_num_workers 4 \
    --lazy_preprocess True \
    --report_to wandb